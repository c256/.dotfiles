65  A
66  B
67  C
68  D
69  E
70  F
71  G
72  H
73  I
74  J
75  K
76  L
77  M
78  N
79  O
80  P
81  Q
82  R
83  S
84  T
85  U
86  V
87  W
88  X
89  Y
90  Z

(/ 4316 65.0)

;; broken
(defun divbyascii (num)
  (setq x 65.0)
  (while (< x 91)
	(if (integerp (/ num x))
		(message "Num %d: %d" num x))
	(setq x (+ 1 x))))

;; also broken
(defun divbyascii (num)
  (setq x 65)
  (while (< x 91)
	(setq f (% num x))
	(if (= f 0) 
		(setq result x)
	  (setq x (+ 1 x)))
	result))

(divbyascii 4316)

