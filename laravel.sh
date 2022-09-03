#!/bin/bash
bd='mysql';
nparam=$#;
currentBash="$(awk -F: -v user="$USER" '$1 == user {print $NF}' /etc/passwd)"

if [ $nparam -gt 1 ] && [ $2 == 'pg' ];
then
    bd='pgsql';
fi
curl -s "https://laravel.build/$1?with=$bd,memcached,redis,mailhog" | bash


# Start the Spinner:
#spin &
# Make a note of its Process ID (PID):
SPIN_PID=$!
# Kill the spinner on any signal, including our own exit.
trap "kill -9 $SPIN_PID" `seq 0 15`

cp for-advanced-coders/.bladeformatterrc $1 -f
cp for-advanced-coders/.eslintrc $1 -f
cp for-advanced-coders/pint.json $1 -f

#include $HOME/bin on your $PATH
if [ `echo $PATH | grep -c "$USER/bin" ` -eq 0 ];
then
    echo "*********************************************************"
    echo "Please, include $HOME/bin on your \$PATH"
    echo "Ex: export PATH=\$PATH:\$HOME/bin on your .bashrc, .zshrc or your shell config file"
fi
mkdir $HOME/bin >> /dev/null 2>&1
cp for-advanced-coders/Scripts/* $HOME/bin/ -Rf
cp for-advanced-coders/sail $HOME/bin/ -f
cd $1
asdf local php 8.1.10
asdf local php 8.1.10

git init

composer require pestphp/pest --dev --with-all-dependencies
composer require pestphp/pest-plugin-laravel --dev
php artisan pest:install
./vendor/bin/pest --init
rm $1/testes/Unit -rf

composer require laravel/pint --dev
./vendor/bin/pint

composer require captainhook/captainhook --dev
cp ../for-advanced-coders/captainhook.json . -f
./vendor/bin/captainhook install -f -s

git add .
git commit -m "Initial commit"

pint
pest

echo "Everything is ready! Now, you can run your project with sail up -d"