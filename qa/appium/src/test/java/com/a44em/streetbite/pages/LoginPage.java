package com.a44em.streetbite.pages;

import io.appium.java_client.AppiumBy;
import io.appium.java_client.android.AndroidDriver;
import java.time.Duration;
import org.openqa.selenium.WebElement;

public final class LoginPage extends BasePage {
  public LoginPage(AndroidDriver driver) {
    super(driver);
  }

  public LoginPage open() {
    if (isPresent(AppiumBy.id("onboarding_continue"), Duration.ofSeconds(5))) {
      driver.findElement(AppiumBy.id("onboarding_continue")).click();
    }
    byIdentifier("auth_submit_button");
    return this;
  }

  public LoginPage enterEmail(String value) {
    WebElement field = byIdentifier("login_email_field");
    field.clear();
    field.sendKeys(value);
    return this;
  }

  public LoginPage enterPassword(String value) {
    WebElement field = byIdentifier("login_password_field");
    field.clear();
    field.sendKeys(value);
    return this;
  }

  public void submit() {
    byIdentifier("auth_submit_button").click();
  }

  public boolean showsText(String text) {
    return isPresent(AppiumBy.xpath("//*[@text=\"" + text + "\"]"), Duration.ofSeconds(20));
  }
}
