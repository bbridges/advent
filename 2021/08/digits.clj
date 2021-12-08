(ns advent-2021.digits
  (:require [clojure.string :as str]))

(defn count-digits
  [input]
  (->> input
       (mapcat second)
       (filter #(contains? #{2 3 4 7} (count %)))
       count))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    (map
     (fn [line] (->> (str/split line #" \| ")
                     (mapv #(str/split % #" "))))
     lines)))

(-> *in* read-input count-digits println)
