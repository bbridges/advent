(ns advent-2021.octopus-two
  (:require [clojure.string :as str]))

(defn energize
  [energies [i j]]
  (if-let [curr (get-in energies [i j])]
    (cond-> (update-in energies [i j] inc)
      (= curr 9) (-> (energize [(inc i) (inc j)])
                     (energize [(inc i) j])
                     (energize [(inc i) (dec j)])
                     (energize [i       (inc j)])
                     (energize [i       (dec j)])
                     (energize [(dec i) (inc j)])
                     (energize [(dec i) j])
                     (energize [(dec i) (dec j)])))
    energies))

(defn reset-flashed [energy] (if (> energy 9) 0 energy))

(defn run-step
  [energies]
  (->> (for [i (range 10) j (range 10)] [i j])
       (reduce #(energize %1 %2) energies)
       (mapv #(mapv reset-flashed %))))

(defn all-flash
  [input]
  (loop [step 1 energies input]
    (let [updated (run-step energies)]
      (if (every? zero? (flatten updated))
        step
        (recur (inc step) updated)))))

(defn read-input
  [stream]
  (mapv (fn [line] (mapv (fn [ch] (- (int ch) 48)) line))
        (str/split-lines (slurp stream))))

(-> *in* read-input all-flash println)
