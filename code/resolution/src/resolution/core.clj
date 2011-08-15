(ns resolution.core)

(def initial-res-state) ; The initial state of the game.
(def update-fn) ; Fn to advance everything one game step.
(def loop-fn) ; Core game loop function.

(defn res-init [initial-state]
  "Initialize Resolution with state as provided in INITIAL-STATE.
   TODO: explain initial-state expects.
   Each hash will get an additional :type member corresponding to its type."
  (def initial-res-state (map #(conj % {:type (str (first %))}) initial-state)))

(defmacro res-update [args & body]
  (def update-fn
    `(fn ~args ~body)))

;; TODO: Could actually wrap in a loop. But then how do we make
;; args explicit?
(defmacro res-loop [args & body]
  (def loop-fn
    `(fn ~args ~body)))

(defn res-start[]
  (let [state initial-res-state]
    (update-fn)))


  
