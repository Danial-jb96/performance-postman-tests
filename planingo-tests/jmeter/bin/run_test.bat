@echo off
setlocal EnableDelayedExpansion

:: پارامترها
set BASE_URL=%1
set NUM_USERS=%2

if "%BASE_URL%"=="" (
  echo [ERROR] BASE_URL is missing!
  goto end
)

if "%NUM_USERS%"=="" (
  echo [ERROR] NUM_USERS is missing!
  goto end
)

:: مسیرهای ثابت
set JMETER_PATH=F:\apache-jmeter-5.6.3\bin\jmeter.bat
set TEST_PLAN=F:\test\performance-postman-tests\planingo-tests\jmeter\tests\planingo_test.jmx
set RESULTS_BASE=F:\test\performance-postman-tests\planingo-tests\jmeter\results

:: پیدا کردن گزارش بعدی
set /A INDEX=1
:find_folder
if exist "%RESULTS_BASE%\report_!INDEX!" (
    set /A INDEX+=1
    goto find_folder
)
set REPORT_FOLDER=%RESULTS_BASE%\report_!INDEX!

echo [INFO] Running test with BASE_URL=%BASE_URL% and NUM_USERS=%NUM_USERS%
echo [INFO] Report will be saved to: !REPORT_FOLDER!

mkdir "!REPORT_FOLDER!"

:: اجرای JMeter
call "%JMETER_PATH%" ^
  -n ^
  -t "%TEST_PLAN%" ^
  -l "!REPORT_FOLDER!\results.csv" ^
  -Jbase_url=%BASE_URL% ^
  -Jnum_users=%NUM_USERS% ^
  -e ^
  -o "!REPORT_FOLDER!"

if errorlevel 1 (
  echo [ERROR] JMeter execution failed.
) else (
  echo [SUCCESS] Test completed successfully!
)

:end
pause
