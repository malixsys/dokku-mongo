#!/usr/bin/env bats
load test_helper

setup() {
  export ECHO_DOCKER_COMMAND="false"
  dokku "$PLUGIN_COMMAND_PREFIX:create" l >&2
}

teardown() {
  export ECHO_DOCKER_COMMAND="false"
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" l >&2
}

@test "($PLUGIN_COMMAND_PREFIX:export) error when there are no arguments" {
  run dokku "$PLUGIN_COMMAND_PREFIX:export"
  assert_contains "${lines[*]}" "Please specify a name for the service"
}

@test "($PLUGIN_COMMAND_PREFIX:export) error when service does not exist" {
  run dokku "$PLUGIN_COMMAND_PREFIX:export" not_existing_service
  assert_contains "${lines[*]}" "service not_existing_service does not exist"
}

@test "($PLUGIN_COMMAND_PREFIX:export) success with SSH_TTY" {
  export ECHO_DOCKER_COMMAND="true"
  export SSH_TTY=`tty`
  run dokku "$PLUGIN_COMMAND_PREFIX:export" l
  password="$(cat "$PLUGIN_DATA_ROOT/l/PASSWORD")"
  assert_exit_status 0
  assert_output "docker exec dokku.mongo.l bash -c DIR=\$(mktemp -d) && mongodump -d l -o \"\$DIR\" -u \"l\" -p \"$password\" --authenticationDatabase \"l\" 1>&2 && tar cf - -C \"\$DIR\" . && rm -rf \"\$DIR\""
}

@test "($PLUGIN_COMMAND_PREFIX:export) success without SSH_TTY" {
  export ECHO_DOCKER_COMMAND="true"
  unset SSH_TTY
  run dokku "$PLUGIN_COMMAND_PREFIX:export" l
  password="$(cat "$PLUGIN_DATA_ROOT/l/PASSWORD")"
  assert_exit_status 0
  assert_output "docker exec dokku.mongo.l bash -c DIR=\$(mktemp -d) && mongodump -d l -o \"\$DIR\" -u \"l\" -p \"$password\" --authenticationDatabase \"l\" 1>&2 && tar cf - -C \"\$DIR\" . && rm -rf \"\$DIR\""
}
