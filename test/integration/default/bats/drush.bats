#!/usr/bin/env bats
@test "drush exists for user vagrant" {
    run su -l vagrant -c drush
    [ "$status" -eq 0 ]
}
