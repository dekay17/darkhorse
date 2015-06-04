#!/bin/bash

psql -U postgres < setup.sql
psql -U lavahound lavahound < create.sql
psql -U lavahound lavahound < data.sql