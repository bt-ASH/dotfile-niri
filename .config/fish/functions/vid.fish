function vid --description '录屏（框选区域，含系统声音）'
    wf-recorder -g "(slurp -d)" \
        -f ~/Videos/(date +%Y-%m-%d_%H-%M-%S).mp4 \
        --codec=libx264rgb \
        --audio=(pactl get-default-sink).monitor
end
