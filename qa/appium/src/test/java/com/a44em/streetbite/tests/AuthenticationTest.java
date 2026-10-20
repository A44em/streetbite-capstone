package com.a44em.streetbite.tests;

import com.a44em.streetbite.core.BaseTest;
import com.a44em.streetbite.pages.HomePage;
import com.a44em.streetbite.pages.LoginPage;
import org.testng.Assert;
import org.testng.SkipException;
import org.testng.annotations.Test;

public final class AuthenticationTest extends BaseTest {
  @Test
  public void validLogin() {
    String email = System.getenv("STREETBITE_TEST_EMAIL");
    String password = System.getenv("STREETBITE_TEST_PASSWORD");
    if (email == null || password == null) {
      throw new SkipException("Real test credentials are not configured.");
    }

    LoginPage login = new LoginPage(driver).open();
    login.enterEmail(email).enterPassword(password).submit();
    new HomePage(driver).waitUntilLoaded();
  }

  @Test
  public void invalidLoginCredentials() throws Exception {
    LoginPage login = new LoginPage(driver).open();
    login.enterEmail("invalid@example.com").enterPassword("wrong-password").submit();
    Assert.assertTrue(login.showsAuthenticationError());
    saveScreenshot("invalid-login-pass");
  }

  @Test
  public void emptyLoginFields() throws Exception {
    LoginPage login = new LoginPage(driver).open();
    login.submit();
    Assert.assertTrue(login.showsText("Please check your input"));
    Assert.assertTrue(login.showsText("Password must be at least 6 characters"));
    saveScreenshot("empty-login-pass");
  }
}
