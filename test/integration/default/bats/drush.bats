#!/usr/bin/env bats
@test "user drush exists" {
    run id -u drush
    [ "$status" -eq 0 ]
}

@test "drush command exists for user drush" {
    run su -l drush -c drush
    [ "$status" -eq 0 ]
}
