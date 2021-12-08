(ns advent-2021.digits-two
  (:require
   [clojure.set :as set]
   [clojure.string :as str]))

(defn get-digits
  [[patterns output]]
  (let [groups (group-by count (map set patterns))
        one         (first (get groups 2))
        four        (first (get groups 4))
        three       (->> (get groups 5)
                         (filter #(= 0 (count (set/difference one %))))
                         first)
        [five two]  (->> (get groups 5)
                         (remove #{three})
                         (sort-by #(count (set/difference four %))))
        six         (->> (get groups 6)
                         (filter #(= 1 (count (set/difference one %))))
                         first)
        [nine zero] (->> (get groups 6)
                         (remove #{six})
                         (sort-by #(count (set/difference four %))))
        seven       (first (get groups 3))
        eight       (first (get groups 7))
        digit-map {zero  0
                   one   1
                   two   2
                   three 3
                   four  4
                   five  5
                   six   6
                   seven 7
                   eight 8
                   nine  9}]
      (->> output
           (map #(get digit-map (set %1)))
           (map-indexed #(apply * (cons %2 (replicate (- 3 %1) 10))))
           (reduce +))))

(defn sum-digits
  [input]
  (reduce + (map get-digits input)))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    (map
     (fn [line] (->> (str/split line #" \| ")
                     (mapv #(str/split % #" "))))
     lines)))

(-> *in* read-input sum-digits println)
