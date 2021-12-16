(ns advent-2021.hex
  (:require [clojure.string :as str]))

(defn parse-binary
  [binary]
  (Integer/parseInt (apply str binary) 2))

(declare next-packet-sum)

(defn next-literal-sum
  [version bits]
  (loop [bits bits]
    (case (first bits)
      \0 [version (drop 5 bits)]
      \1 (recur (drop 5 bits)))))

(defn next-op-len-sum
  [version bits]
  (let [[len-bits bits] (split-at 15 bits)
        [sub-bits bits] (split-at (parse-binary len-bits) bits)]
    (loop [sum version
           sub-bits sub-bits]
      (if (seq sub-bits)
        (let [[version sub-bits] (next-packet-sum sub-bits)]
          (recur (+ sum version) sub-bits))
        [sum bits]))))

(defn next-op-count-sum
  [version bits]
  (let [[count-bits bits] (split-at 11 bits)]
    (loop [remaining (parse-binary count-bits)
           sum version
           bits bits]
      (if (pos? remaining)
        (let [[version bits] (next-packet-sum bits)]
          (recur (dec remaining) (+ sum version) bits))
        [sum bits]))))

(defn next-packet-sum
  [bits]
  (let [[version-bits bits] (split-at 3 bits)
        version (parse-binary version-bits)
        [id-bits bits] (split-at 3 bits)]
    (cond
      (= id-bits [\1 \0 \0]) (next-literal-sum version bits)
      (= (first bits) \0)    (next-op-len-sum version (rest bits))
      (= (first bits) \1)    (next-op-count-sum version (rest bits)))))

(defn version-sum
  [input]
  (first (next-packet-sum input)))

(defn read-input
  [stream]
  (mapcat #(case %
             \0 "0000"
             \1 "0001"
             \2 "0010"
             \3 "0011"
             \4 "0100"
             \5 "0101"
             \6 "0110"
             \7 "0111"
             \8 "1000"
             \9 "1001"
             \A "1010"
             \B "1011"
             \C "1100"
             \D "1101"
             \E "1110"
             \F "1111")
          (str/trim (slurp stream))))

(-> *in* read-input version-sum println)
