meson --prefix=%LIBRARY_PREFIX% ^
    --libdir=%LIBRARY_PREFIX%\lib ^
    --buildtype=release ^
    --wrap-mode=nofallback ^
    build || goto :error
meson compile -C build -v || goto :error
meson install -C build || goto :error

if "%compat%" == "yes" (
    copy %LIBRARY_PREFIX%\bin\pkgconf.exe %LIBRARY_PREFIX%\bin\pkg-config.exe || goto :error
)

:: Copy the [de]activate scripts to %PREFIX%\etc\conda\[de]activate.d.
:: This will allow them to be run on environment activation.
FOR %%F IN (activate deactivate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d MKDIR %PREFIX%\etc\conda\%%F.d || goto :error
    copy %RECIPE_DIR%\scripts\%%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat || goto :error
)

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
