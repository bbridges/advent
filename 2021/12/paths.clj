(ns advent-2021.paths
  (:require
   [clojure.set :as set]
   [clojure.string :as str]))

(defn count-paths
  ([input]
   (let [caves (->> input
                    (map (fn [[left right]]
                           (hash-map left #{right} right #{left})))
                    (apply merge-with into))]
     (count-paths caves "start" #{"start"})))
  ([caves curr visited]
   (case curr
     "end" 1
     (let [next (set/difference (get caves curr) visited)
           visited (cond-> visited
                     (Character/isLowerCase (get curr 0)) (conj curr))]
       (reduce + (map #(count-paths caves % visited) next))))))

(defn read-input
  [stream]
  (let [lines (str/split-lines (slurp stream))]
    (mapv #(str/split % #"-") lines)))

(-> *in* read-input count-paths println)
