package com.a44em.streetbite.pages;

import io.appium.java_client.AppiumBy;
import io.appium.java_client.android.AndroidDriver;
import java.time.Duration;
import java.util.Map;
import org.openqa.selenium.Rectangle;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public final class LoginPage extends BasePage {
  public LoginPage(AndroidDriver driver) {
    super(driver);
  }

  public LoginPage open() {
    var onboarding = identifier("onboarding_continue");
    var submit = identifier("auth_submit_button");
    // An overloaded emulator can raise a system ANR dialog over the app; choose
    // "Wait" so the app keeps running. The overall wait stays bounded.
    var anrWait = AppiumBy.id("android:id/aerr_wait");
    new WebDriverWait(driver, Duration.ofSeconds(60)).until(ignored -> {
      var dialogs = driver.findElements(anrWait);
      if (!dialogs.isEmpty()) {
        dialogs.get(0).click();
        return false;
      }
      return !driver.findElements(onboarding).isEmpty()
          || !driver.findElements(submit).isEmpty();
    });
    if (!driver.findElements(onboarding).isEmpty()) {
      driver.findElement(onboarding).click();
    }
    byIdentifier("auth_submit_button");
    return this;
  }

  public LoginPage enterEmail(String value) {
    enterText("login_email_field", value);
    return this;
  }

  public LoginPage enterPassword(String value) {
    enterText("login_password_field", value);
    return this;
  }

  private void enterText(String identifier, String value) {
    WebElement field = byIdentifier(identifier);
    Rectangle bounds = field.getRect();
    driver.executeScript("mobile: clickGesture", Map.of(
        "x", bounds.getX() + bounds.getWidth() / 2,
        "y", bounds.getY() + bounds.getHeight() / 2));
    wait.until(ExpectedConditions.attributeToBe(field, "focused", "true"));
    field.clear();
    field.sendKeys(value);
    wait.until(ignored -> !field.getAttribute("text").isBlank());
  }

  public void submit() {
    try {
      driver.hideKeyboard();
    } catch (RuntimeException ignored) {
      // The keyboard may already be hidden.
    }
    byIdentifier("auth_submit_button").click();
  }

  public boolean showsText(String text) {
    return isPresent(AppiumBy.xpath(
        "//*[@text=\"" + text + "\" or @content-desc=\"" + text + "\"]"),
        Duration.ofSeconds(20));
  }

  public boolean showsAuthenticationError() {
    try {
      // Only the credential-specific message counts; the generic error indicates
      // a network/backend failure rather than rejected credentials.
      new WebDriverWait(driver, Duration.ofSeconds(45)).until(ignored ->
          !driver.findElements(AppiumBy.accessibilityId("Invalid email or password")).isEmpty());
      return true;
    } catch (RuntimeException ignored) {
      return false;
    }
  }
}
