function vid_full --description '录屏（当前焦点输出全屏，含系统声音）'
    set -l geometry (swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
    wf-recorder -g "$geometry" \
        -f ~/Videos/(date +%Y-%m-%d_%H-%M-%S).mp4 \
        --codec=libx264rgb \
        --audio=(pactl get-default-sink).monitor
end
