#!/usr/bin/env bash

workspace4() {
  local window_list="$(aerospace list-windows --all --json)"
  local arc="$(echo "$window_list" | jq '.[] | select(."window-title" == "Dashboard | Cloud Key") | ."window-id"')"
  local discord="$(echo "$window_list" | jq '.[] | select(."app-name" == "Discord") | ."window-id"')"
  local messages="$(echo "$window_list" | jq '.[] | select(."app-name" == "Messages") | ."window-id"')"
  local spotify="$(echo "$window_list" | jq '.[] | select(."window-title" == "Spotify MiniPlayer") | ."window-id"')"

  aerospace workspace 4

  aerospace move-node-to-workspace --window-id "$arc" 4
  aerospace move-node-to-workspace --window-id "$discord" 4
  aerospace move-node-to-workspace --window-id "$messages" 4
  aerospace move-node-to-workspace --window-id "$spotify" 4

  aerospace flatten-workspace-tree --workspace 4
  aerospace balance-sizes --workspace 4

  aerospace move --window-id "$arc" left
  aerospace move --window-id "$arc" left
  aerospace move --window-id "$arc" left

  aerospace move --window-id "$discord" right

  aerospace join-with --window-id "$messages" right
  aerospace move --window-id "$messages" down

  aerospace join-with --window-id "$spotify" right
  aerospace move --window-id "$spotify" down

  aerospace join-with --window-id "$messages" down

  aerospace resize --window-id "$arc" width 822
  aerospace resize --window-id "$arc" height 1030

  aerospace resize --window-id "$discord" width 940
  aerospace resize --window-id "$discord" height 659

  aerospace resize --window-id "$spotify" width 258
  aerospace resize --window-id "$spotify" height 359

  aerospace resize --window-id "$messages" width 658
  aerospace resize --window-id "$messages" height 359
}

workspace5() {
  local window_list="$(aerospace list-windows --all --json)"
  local calendar="$(echo "$window_list" | jq '.[] | select(."app-name" == "Calendar") | ."window-id"')"
  local mail="$(echo "$window_list" | jq '.[] | select(."app-name" == "Mail") | ."window-id"')"

  aerospace workspace 5

  aerospace move-node-to-workspace --window-id "$calendar" 5
  aerospace move-node-to-workspace --window-id "$mail" 5

  aerospace flatten-workspace-tree --workspace 5
  aerospace balance-sizes --workspace 5

  aerospace move --window-id "$calendar" left
  aerospace move --window-id "$mail" right
}

main() {
  workspace4
  workspace5

  aerospace workspace 4
}

main "@$"
