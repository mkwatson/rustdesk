#!/bin/bash

# Define the old and new package names.
OLD_PACKAGE_NAME="com.carriez.flutter_hbb"
NEW_PACKAGE_NAME="dev.crab.cake"

# Update the package name in AndroidManifest.xml files.
echo "Updating package name in AndroidManifest.xml files..."
find android/app/src/ -type f -name "AndroidManifest.xml" | while read manifest; do
  sed -i '' "s/package=\"$OLD_PACKAGE_NAME\"/package=\"$NEW_PACKAGE_NAME\"/" "$manifest"
done

# Update the applicationId in the app/build.gradle file.
echo "Updating applicationId in build.gradle..."
sed -i '' "s/applicationId \"$OLD_PACKAGE_NAME\"/applicationId \"$NEW_PACKAGE_NAME\"/" android/app/build.gradle

# Move Java/Kotlin files to the new directory structure.
echo "Moving Java/Kotlin files to the new directory structure..."
OLD_DIR_PATH="${OLD_PACKAGE_NAME//./\/}"
NEW_DIR_PATH="${NEW_PACKAGE_NAME//./\/}"
mkdir -p "android/app/src/main/java/$NEW_DIR_PATH"
mv "android/app/src/main/java/$OLD_DIR_PATH/"* "android/app/src/main/java/$NEW_DIR_PATH/" 2>/dev/null
rmdir "android/app/src/main/java/$OLD_DIR_PATH" 2>/dev/null

# Update package declarations in Java/Kotlin files.
echo "Updating package declarations in Java/Kotlin files..."
for file in $(find android/app/src/main/java/$NEW_DIR_PATH -type f \( -name "*.java" -o -name "*.kt" \)); do
  sed -i '' "s/package $OLD_PACKAGE_NAME/package $NEW_PACKAGE_NAME/" $file
done

echo "Script execution complete."
echo "Please manually verify the changes, especially in build variant-specific directories (debug, profile)."
echo "Test the application to ensure that everything is functioning correctly."
