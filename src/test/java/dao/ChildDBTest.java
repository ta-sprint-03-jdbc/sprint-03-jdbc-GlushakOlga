package dao;

import model.Child;
import org.junit.jupiter.api.*;
import utils.DBUtil;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.Period;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Child Database Operations Tests")
class ChildDBTest {

    private ChildDB db;

    @BeforeEach
    void setUp() throws SQLException, IOException {
        new DBUtil().executeFile("init.sql");
        db = new ChildDB();
    }

    @AfterEach
    void tearDown() throws Exception {
        try (Connection conn = DBUtil.getConnection();
                Statement st = conn.createStatement()) {
            st.execute("TRUNCATE TABLE child CASCADE");
        }
        db.close();
    }

    @Test
    @DisplayName("Should add a child and return it with an ID")
    void addShouldAddChildAndReturnWithId() throws SQLException {
        // Arrange
        String firstName = "John";
        String lastName = "Doe";
        LocalDate birthDate = LocalDate.of(2010, 1, 1);
        Child child = new Child(firstName, lastName, birthDate);

        // Act
        Child addedChild = db.addChild(child);
        System.out.println("[DEBUG_LOG] Added child ID: " + addedChild.id());

        // Assert
        assertNotNull(addedChild.id(), "Child ID should not be null");
        assertEquals(firstName, addedChild.firstName(), "First name should match");
        assertEquals(lastName, addedChild.lastName(), "Last name should match");
        assertEquals(birthDate, addedChild.birthDate(), "Birth date should match");
    }

    @Test
    @DisplayName("Should add a child with null birth date")
    void addShouldHandleNullBirthDate() throws SQLException {
        // Arrange
        String firstName = "John";
        String lastName = "Doe";
        Child child = new Child(firstName, lastName, null);
        // Act
        Child addedChild = db.addChild(child);
        // Assert
        assertNotNull(addedChild.id(), "Child ID should not be null");
        assertEquals(firstName, addedChild.firstName(), "First name should match");
        assertEquals(lastName, addedChild.lastName(), "Last name should match");
        assertNull(addedChild.birthDate(), "Birth date should be null");

    }

    @Test
    @DisplayName("Should update an existing child")
    void updateShouldUpdateExistingChild() throws SQLException {
        // Arrange - Add a child first
        Child child = new Child("John", "Doe", LocalDate.of(2010, 1, 1));
        Child addedChild = db.addChild(child);
        // Create updated child
        Child updateChild = new Child(
                addedChild.id(),
                "John",
                "Doe",
                LocalDate.of(2011, 2, 2));
        // Act
        db.updateChild(updateChild);
        // Assert

        // Verify the update by querying the database
        List<Child> children = db.findChildrenWithMinimumAge(0);
        assertTrue(children.contains(updateChild), "Updated child should exist in database");

    }

    @Test
    @DisplayName("Should delete an existing child")
    void deleteShouldDeleteExistingChild() throws SQLException {
        // Arrange - Add a child first
        Child child = new Child("John", "Doe", LocalDate.of(2010, 1, 1));
        Child addedChild = db.addChild(child);
        // Act
        db.deleteChild(addedChild.id());
        // Assert
        // Verify the deletion by querying the database
        List<Child> children = db.findChildrenWithMinimumAge(0);
        assertFalse(children.contains(addedChild), "Deleted child should not exist in database");
    }

    @Test
    @DisplayName("Should return children with at least the specified age")
    void findChildrenWithMinimumAgeShouldReturnChildrenWithMinimumAge() throws SQLException {
        // Arrange - Add children with different ages
        LocalDate today = LocalDate.now();
        // Child 1 - 10 years old
        Child child1 = db.addChild(new Child("Child", "Ten", today.minusYears(10)));
        // Child 2 - 5 years old
        Child child2 = db.addChild(new Child("Child", "Five", today.minusYears(5)));
        // Child 3 - 15 years old
        Child child3 = db.addChild(new Child("Child", "Fifteen", today.minusYears(15)));
        // Act - Get all children at least 10 years old
        List<Child> result = db.findChildrenWithMinimumAge(0);
        // Assert
        assertTrue(result.contains(child1), "10-years-old child should be included");
        assertTrue(result.contains(child2), "5-years-old child should NOT be included");
        assertTrue(result.contains(child3), "15-years-old child should be included");
        // Verify that the result contains children with correct ages
        for (Child child : result) {
            assertNotNull(child.birthDate(), "Birth date should not be null");
            int age = Period.between(child.birthDate(), today).getYears();
            assertTrue(age >= 10, "Child age should be at least 10");
        }

    }

    @Test
    @DisplayName("Should return children with null birth date")
    void findChildrenWithoutBirthDateShouldReturnChildrenWithNullBirthDate() throws SQLException {
        // Arrange - Add children with and without birth dates
        // Child with birth date
        Child childWithBirthDate = db.addChild(
                new Child("John", "Doe", LocalDate.of(2010, 1, 1)));
        // Child without birth date
        Child childWithoutBirthDate = db.addChild(
                new Child("Jane", "Doe", null));
        // Act
        List<Child> result = db.findChildrenWithoutBirthDate();
        // Assert
        assertTrue(result.contains(childWithoutBirthDate), "Child with null birth date should be returned");
        assertFalse(result.contains(childWithBirthDate), "Child with birth date shold Not be returned");
        // Verify that the result contains the child without birth date
        for (Child child : result) {
            assertNull(child.birthDate(), "Birth date should be null");
        }

    }
}
