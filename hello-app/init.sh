#!/bin/bash
bin/rails db:migrate
exec bin/rails server
