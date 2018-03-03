(ql:quickload "lispbuilder-sdl")
(defparameter *random-color* sdl:*white*)

(defun ft_print_box (x_ y_ size)
  (sdl:draw-box (sdl:rectangle-from-midpoint-*  (+ x_ (floor size 2))  (+ y_(floor size 2)) size size)
    :color *random-color*)
)

(defun ft_print_gui_board (arr x y tile_size)
  (sdl:clear-display sdl:*black*)
  (dotimes (y2 y)
    (dotimes (x2 x)
      (if (eq (eq (aref arr y2 x2) 0) T)
        (ft_print_box (+ 1 (* x2 tile_size) move_x) (+ 1 (* y2 tile_size) move_y) (- tile_size (floor tile_size 10))))))
  (sdl:update-display))

(defun ft_print_cli_board (arr x y)
  (terpri)
  (loop for y2 from 0 to (- y 1) do
    (loop for x2 from 0 to (- x 1) do
      (if (eq (eq (aref arr y2 x2) 0) T)
        (write '-))
      (if (eq (eq (aref arr y2 x2) 1) T)
        (write-char #\#)))
    (terpri)))

(defun ft_loop (tile_size)
  (sdl:with-init ()
  (sdl:window width height :title-caption "TG FDP")
  (setf (sdl:frame-rate) 60)
  (sdl:update-display)
  (sdl:enable-key-repeat nil nil)
  (sdl:with-events ()
    (:quit-event () t)
    (:video-expose-event () (sdl:update-display))
    (:key-down-event (:key key)
	  (when (sdl:key= key :sdl-key-escape)
        (sdl:push-quit-event))
	  (when (or (sdl:key= key :sdl-key-left) (sdl:key= key :sdl-key-a))
        (setf move_x (+ move_x move_speed)))
	  (when (or (sdl:key= key :sdl-key-right) (sdl:key= key :sdl-key-d))
        (setf move_x (- move_x move_speed)))
	  (when (or (sdl:key= key :sdl-key-up) (sdl:key= key :sdl-key-w))
        (setf move_y (+ move_y move_speed)))
	  (when (or (sdl:key= key :sdl-key-down) (sdl:key= key :sdl-key-s))
        (setf move_y (- move_y move_speed)))
      (when (or (sdl:key= key :sdl-key-q) (sdl:key= key :sdl-key-kp-minus))
        (setf tile_size (- tile_size zoom_dec_speed)))
      (when (or (sdl:key= key :sdl-key-e) (sdl:key= key :sdl-key-kp-plus))
        (setf tile_size (+ tile_size zoom_dec_speed)))
      (ft_print_gui_board arr x y tile_size)
	)
    (:idle ()
      (when (sdl:mouse-left-p)
	    (let 
			 ((i_tab (floor (- (sdl:mouse-y) move_y) tile_size))
			  (j_tab (floor (- (sdl:mouse-x) move_x) tile_size)))
		  (if (eq (and (>= i_tab 0) (< i_tab y) (>= j_tab 0) (< j_tab x)) T)
          	(setf (aref arr i_tab j_tab) 1)
		  )
		)
	  )
        (ft_print_gui_board arr x y tile_size)
        (sdl:update-display)))))
