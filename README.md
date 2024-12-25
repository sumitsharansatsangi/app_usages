# app_usages_plus

**A plugin to get app usage information for android devices using start date, end date and packages
for whitelist.**

## Features

* Get usages information for apps:
    - App name
    - package name
    - Install time
    - Icon (Base64 to Uint8List)
    - Usage in milliseconds with timestamp

## Required permissions

- `android.permission.QUERY_ALL_PACKAGES`
- `android.permission.PACKAGE_USAGE_STATS`

## Usage

* To get app usage information:

`final usages = await AppUsagePlugin.getAppUsageStats(startDate, endDate, packageNames: ['com.whatsapp','com.instagram.android'],);`

* Parameters

- `startDate`: DateTime
- `endDate`: DateTime
- `packageNames`: List<String.>?

* if you want to get information about limited applications, you can pass the `packageNames`
  parameter.
