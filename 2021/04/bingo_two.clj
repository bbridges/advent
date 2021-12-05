(ns advent-2021.bingo-two
  (:require [clojure.string :as str]))

(defn winner?
  [board]
  (->> board
       (partition 5)
       (#(concat (mapv vec %) (apply mapv vector %)))
       (filter #(every? (partial = -1) %))
       not-empty
       some?))

(defn mark-board
  [board number]
  (let [index (.indexOf board number)]
    (if (= index -1)
      board
      (assoc board index -1))))

(defn play-bingo
  [input]
  (loop [rem-numbers (:numbers input)
         boards (:boards input)]
    (let [number (first rem-numbers)
          updated (map #(mark-board % number) boards)]
      (if-let [losers (seq (remove winner? updated))]
        (recur (rest rem-numbers) losers)
        (* number (reduce + 0 (map (partial max 0) (last updated))))))))

(defn read-input
  [stream]
  (let [raw (str/trim (slurp stream))
        lines (str/split-lines raw)
        numbers (->> lines
                     first
                     (#(str/split % #","))
                     (map #(Integer/parseInt %)))
        boards (->> lines
                    (drop 2)
                    (partition 5 6)
                    (map (fn [line]
                           (->> line
                                (map #(str/split % #" "))
                                flatten
                                (remove empty?)
                                (mapv #(Integer/parseInt %))))))]
    {:numbers numbers, :boards boards}))

(-> *in* read-input play-bingo println)
