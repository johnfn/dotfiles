(ns sample.core
  (:use resolution.core))

;;;; This is a sample project intended to show how to use Resolution.


;; initialization and update of state have really similar parts. I wonder if they can
;; be joined together somehow.

;; TODO: type is a redundancy here. (with res-init)
(res-init
  { :player {:x 5 :y 5 :color 'red}
    :background-color {:color 'white}
  })

(defn map-hash [update-fn hash]
  "replace every key, value pair of HASH with key, (fn key value)"
  (into {} (map (fn [key-value] (assoc key-value 1 (apply update-fn key-value))) (into [] hash))))

(res-update [old-state keys]
  ;;these multimethods must be defined inside res-update in order to gain
  ;; closures over state etc. 
            
  (defmulti update-object [object] :type)

  (defmethod update-player :player
    {:x 4 :y 4 :type :player})
  (defmethod update-color :color
    {:color 'white :type :color})

  (defn new-objects [old-state]
    [:game-over true])
  
  ; map can update extant items and remove them, but not add.
  ; for some odd reason i cannot think of a better way to solve this.
  (conj
   (map-hash #(update-object % old-state keys) old-state)
   (new-objects old-state)))

(defn end-game[]
  (println "GAME OVER."))

(res-loop [{screen :screen} game-stuff] ;pretty poor naming scheme
  (loop {:screen screen
         :game-state state}
    (render-game)
    (if (:game-over state)
      (end-game)
      (recur
       {:screen screen
        :game-state (res-update game-state)
        }))))

(defn -main[]
  (res-start))

(-main)
