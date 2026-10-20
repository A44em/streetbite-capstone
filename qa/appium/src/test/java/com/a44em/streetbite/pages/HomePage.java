package com.a44em.streetbite.pages;

import io.appium.java_client.AppiumBy;
import io.appium.java_client.android.AndroidDriver;
import java.time.Duration;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public final class HomePage extends BasePage {
  private static final By FIRST_ADD_BUTTON =
      AppiumBy.xpath("//*[contains(@resource-id, 'add_to_cart_')]");

  public HomePage(AndroidDriver driver) {
    super(driver);
  }

  public HomePage waitUntilLoaded() {
    // Firebase sign-in latency on the emulator varied from 3 s to over 35 s, so
    // the post-login wait is longer than the default element wait but bounded.
    new WebDriverWait(driver, Duration.ofSeconds(60))
        .until(ExpectedConditions.presenceOfElementLocated(identifier("meal_grid")));
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
    return showsText("Your cart is empty");
  }

  public boolean showsAddedFeedback() {
    return showsText("Added to cart");
  }

  // Flutter exposes Text widgets as content-desc, so match either attribute.
  private boolean showsText(String text) {
    return isPresent(AppiumBy.xpath(
        "//*[@text=\"" + text + "\" or @content-desc=\"" + text + "\"]"),
        Duration.ofSeconds(8));
  }
}
