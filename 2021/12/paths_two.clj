(ns advent-2021.paths-two
  (:require
   [clojure.set :as set]
   [clojure.string :as str]))

(defn count-paths
  ([input]
   (let [caves (->> input
                    (map (fn [[left right]]
                           (hash-map left #{right} right #{left})))
                    (apply merge-with into))]
     (count-paths caves "start" #{} false)))
  ([caves curr visited extra]
   (case curr
     "end" 1
     (let [[visited extra] (if (or (= curr "start")
                                   (Character/isUpperCase (get curr 0)))
                             [visited extra]
                             [(conj visited curr)
                              (or extra (contains? visited curr))])
           next (cond-> (disj (get caves curr) "start")
                  extra (set/difference visited))]
       (reduce + (map #(count-paths caves % visited extra) next))))))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    (mapv #(str/split % #"-") lines)))

(-> *in* read-input count-paths println)
