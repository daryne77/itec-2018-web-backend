@echo off

IF NOT EXIST venv (
    echo python system interpreter:
    where python
    python --version || goto :error
    echo creating new virtualenv...
    python -m venv venv || goto :error
)

echo activating venv
call deactivate >NUL 2>NUL
call venv\Scripts\activate.bat
echo python version:
python --version
echo pip version:
pip --version
echo installing requirements...
python -m pip install -U pip || goto :error
pip install -U --find-links=wheels -r requirements.txt || goto :error
echo setting up database...
python manage.py migrate || goto :error
echo ensuring admin user...
python manage.py shell -c "import createsuperuser"
goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
