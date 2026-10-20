package com.a44em.streetbite.pages;

import io.appium.java_client.AppiumBy;
import io.appium.java_client.android.AndroidDriver;
import java.time.Duration;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.ExpectedConditions;

public final class HomePage extends BasePage {
  private static final By FIRST_ADD_BUTTON =
      AppiumBy.xpath("//*[contains(@resource-id, 'add_to_cart_')]");

  public HomePage(AndroidDriver driver) {
    super(driver);
  }

  public HomePage waitUntilLoaded() {
    byIdentifier("meal_grid");
    return this;
  }

  public void scrollMealsForward() {
    driver.findElement(AppiumBy.androidUIAutomator(
        "new UiScrollable(new UiSelector().scrollable(true)).scrollForward()"));
  }

  public void addFirstVisibleMeal() {
    wait.until(ExpectedConditions.elementToBeClickable(FIRST_ADD_BUTTON)).click();
  }

  public void openCart() {
    byIdentifier("open_cart").click();
  }

  public boolean showsEmptyCart() {
    return isPresent(AppiumBy.xpath("//*[@text='Your cart is empty']"), Duration.ofSeconds(8));
  }

  public boolean showsAddedFeedback() {
    return isPresent(AppiumBy.xpath("//*[@text='Added to cart']"), Duration.ofSeconds(8));
  }
}
