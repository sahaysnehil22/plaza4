plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

fun stringPropertyOrEnv(name: String): String? =
    (project.findProperty(name) as String?)?.takeIf { it.isNotBlank() }
        ?: System.getenv(name)?.takeIf { it.isNotBlank() }

val releaseStoreFile = stringPropertyOrEnv("PLAZA4_UPLOAD_STORE_FILE")
val releaseStorePassword = stringPropertyOrEnv("PLAZA4_UPLOAD_STORE_PASSWORD")
val releaseKeyAlias = stringPropertyOrEnv("PLAZA4_UPLOAD_KEY_ALIAS")
val releaseKeyPassword = stringPropertyOrEnv("PLAZA4_UPLOAD_KEY_PASSWORD")
val hasReleaseSigning = listOf(
    releaseStoreFile,
    releaseStorePassword,
    releaseKeyAlias,
    releaseKeyPassword,
).all { !it.isNullOrBlank() }

android {
    namespace = "pe.plaza4.plaza4_customer"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "pe.plaza4.plaza4_customer"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["APP_LABEL"] = "Plaza 4"
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] =
            stringPropertyOrEnv("GOOGLE_MAPS_API_KEY")
                ?: ""
    }

    flavorDimensions += "app"
    productFlavors {
        create("customer") {
            dimension = "app"
            applicationId = "pe.plaza4.customer"
            manifestPlaceholders["APP_LABEL"] = "Plaza 4"
        }
        create("driver") {
            dimension = "app"
            applicationId = "pe.plaza4.driver"
            manifestPlaceholders["APP_LABEL"] = "Plaza 4 Driver"
        }
    }

    signingConfigs {
        create("release") {
            if (hasReleaseSigning) {
                storeFile = file(releaseStoreFile!!)
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

tasks.configureEach {
    if ((name.startsWith("assemble") || name.startsWith("bundle")) &&
        name.endsWith("Release")) {
        doFirst {
            if (!hasReleaseSigning) {
                throw GradleException(
                    "Plaza 4 release signing is not configured. Set PLAZA4_UPLOAD_STORE_FILE, " +
                        "PLAZA4_UPLOAD_STORE_PASSWORD, PLAZA4_UPLOAD_KEY_ALIAS, and " +
                        "PLAZA4_UPLOAD_KEY_PASSWORD via Gradle properties or environment variables."
                )
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.2")
}
