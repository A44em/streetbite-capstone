package com.a44em.streetbite.tests;

import com.a44em.streetbite.core.BaseTest;
import com.a44em.streetbite.pages.HomePage;
import com.a44em.streetbite.pages.LoginPage;
import org.testng.Assert;
import org.testng.SkipException;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

public final class HomeTest extends BaseTest {
  private HomePage home;

  @BeforeMethod(alwaysRun = true)
  public void signIn() {
    String email = System.getenv("STREETBITE_TEST_EMAIL");
    String password = System.getenv("STREETBITE_TEST_PASSWORD");
    if (email == null || password == null) {
      throw new SkipException("Real test credentials are not configured.");
    }
    LoginPage login = new LoginPage(driver).open();
    login.enterEmail(email).enterPassword(password).submit();
    home = new HomePage(driver).waitUntilLoaded();
  }

  @Test
  public void scrollThroughMealGrid() {
    home.scrollMealsForward();
  }

  @Test
  public void addMealShowsSnackBar() {
    home.addFirstVisibleMeal();
    Assert.assertTrue(home.showsAddedFeedback());
  }
}
