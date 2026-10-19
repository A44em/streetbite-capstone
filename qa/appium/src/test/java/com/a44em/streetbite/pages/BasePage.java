package com.a44em.streetbite.pages;

import io.appium.java_client.AppiumBy;
import io.appium.java_client.android.AndroidDriver;
import java.time.Duration;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

abstract class BasePage {
  protected final AndroidDriver driver;
  protected final WebDriverWait wait;

  BasePage(AndroidDriver driver) {
    this.driver = driver;
    this.wait = new WebDriverWait(driver, Duration.ofSeconds(20));
  }

  protected WebElement byIdentifier(String identifier) {
    return wait.until(ExpectedConditions.presenceOfElementLocated(AppiumBy.id(identifier)));
  }

  protected boolean isPresent(By locator, Duration timeout) {
    try {
      new WebDriverWait(driver, timeout)
          .until(ExpectedConditions.presenceOfElementLocated(locator));
      return true;
    } catch (RuntimeException ignored) {
      return false;
    }
  }
}
