(ns advent-2021.syntax-two
  (:require [clojure.string :as str]))

(def closer {\( \), \[ \], \{ \}, \< \>})
(def score {\) 1, \] 2, \} 3, \> 4})

(defn closing-chars
  ([line]
   (closing-chars line '()))
  ([line stack]
   (let [ch (first line)]
     (cond
       (nil? ch)                    (map closer stack)
       (contains? closer ch)        (recur (subs line 1) (conj stack ch))
       (= ch (closer (peek stack))) (recur (subs line 1) (pop stack))
       :else                        nil))))

(def xf (comp (map closing-chars)
              (filter some?)
              (map #(reduce (fn [s ch] (+ (* 5 s) (score ch))) 0 %))))

(defn mid [v] (nth v (/ (dec (count v)) 2)))

(defn error-score
  [input]
  (mid (sort (eduction xf input))))

(defn read-input
  [stream]
  (str/split-lines (slurp stream)))

(-> *in* read-input error-score println)
