## venv utils
sibple bash function, make easy to use python module venv

#### view venv commands
```bash
venv help
```

#### call venv molude to create virtual environment as .venv
```bash
venv init
```

#### call venv molude to create virtual environment as .venv with specific python version, ex: 3.11 (need to be installed)
```bash
venv init 3.11
```

#### install libs from requirements.txt
```bash
venv install
```

#### save requirements to requirements.txt
```bash
venv save
```

#### load virtual environment from [ .venv || venv ]
```bash
venv in
```

#### deactivate virtual environment
```bash
venv out
```

#### remove verv directory
```bash
venv remove
```
