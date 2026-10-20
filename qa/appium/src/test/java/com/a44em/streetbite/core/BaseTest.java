package com.a44em.streetbite.core;

import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.options.UiAutomator2Options;
import java.io.File;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.Duration;
import org.openqa.selenium.OutputType;
import org.testng.ITestResult;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;

public abstract class BaseTest {
  protected AndroidDriver driver;

  @BeforeMethod(alwaysRun = true)
  public void startDriver() throws Exception {
    String apk = environment("APK_PATH", "../../build/app/outputs/flutter-apk/app-debug.apk");
    Path apkPath = Path.of(apk).toAbsolutePath().normalize();
    if (!apkPath.toFile().isFile()) {
      throw new IllegalStateException("APK not found: " + apkPath);
    }

    UiAutomator2Options options = new UiAutomator2Options()
        .setDeviceName(environment("ANDROID_DEVICE_NAME", "Android Emulator"))
        .setApp(apkPath.toString())
        .setAppPackage("com.a44em.streetbite")
        .setAppActivity(".MainActivity")
        .setNoReset(false)
        .setAutoGrantPermissions(true)
        .setNewCommandTimeout(Duration.ofSeconds(120));
    options.setCapability("appium:adbExecTimeout", 120000);
    options.setCapability("appium:androidInstallTimeout", 180000);
    options.setCapability("appium:uiautomator2ServerInstallTimeout", 120000);
    options.setCapability("appium:uiautomator2ServerLaunchTimeout", 120000);
    String udid = System.getenv("ANDROID_UDID");
    if (udid != null && !udid.isBlank()) {
      options.setUdid(udid);
    }

    driver = new AndroidDriver(
        URI.create(environment("APPIUM_SERVER_URL", "http://127.0.0.1:4723")).toURL(),
        options);
    driver.manage().timeouts().implicitlyWait(Duration.ZERO);
  }

  @AfterMethod(alwaysRun = true)
  public void stopDriver(ITestResult result) throws Exception {
    if (driver == null) {
      return;
    }
    if (!result.isSuccess()) {
      saveScreenshot(result.getMethod().getMethodName());
      savePageSource(result.getMethod().getMethodName());
    }
    driver.quit();
  }

  protected void saveScreenshot(String name) throws Exception {
    File source = driver.getScreenshotAs(OutputType.FILE);
    Path target = Path.of("target", "screenshots", name + ".png");
    Files.createDirectories(target.getParent());
    Files.copy(source.toPath(), target, StandardCopyOption.REPLACE_EXISTING);
  }

  protected void savePageSource(String name) throws Exception {
    Path target = Path.of("target", "page-source", name + ".xml");
    Files.createDirectories(target.getParent());
    Files.writeString(target, driver.getPageSource());
  }

  protected static String environment(String name, String fallback) {
    String value = System.getenv(name);
    return value == null || value.isBlank() ? fallback : value;
  }
}
