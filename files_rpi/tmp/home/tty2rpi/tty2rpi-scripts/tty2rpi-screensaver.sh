#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

KILLPID feh
feh -q -F -z /dev/shm/*
