(ns advent-2021.syntax
  (:require [clojure.string :as str]))

(def closer {\( \), \[ \], \{ \}, \< \>})
(def score {\) 3, \] 57, \} 1197, \> 25137})

(defn illegal-char
  ([line]
   (illegal-char line '()))
  ([line stack]
   (let [ch (first line)]
     (cond
       (nil? ch)                    nil
       (contains? closer ch)        (recur (subs line 1) (conj stack ch))
       (= ch (closer (peek stack))) (recur (subs line 1) (pop stack))
       :else                        ch))))

(def xf (comp (map illegal-char)
              (filter some?)
              (map #(get score %))))

(defn error-score
  [input]
  (transduce xf + input))

(defn read-input
  [stream]
  (str/split-lines (slurp stream)))

(-> *in* read-input error-score println)
