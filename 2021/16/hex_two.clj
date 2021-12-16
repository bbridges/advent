(ns advent-2021.hex-two
  (:require [clojure.string :as str]))

(defn parse-binary
  [binary]
  (Long/parseLong (apply str binary) 2))

(declare next-packet)

(defn next-literal
  [bits]
  (loop [literal-bits []
         bits bits]
    (let [[curr-bits bits] (split-at 5 bits)
          literal-bits (into literal-bits (rest curr-bits))]
      (case (first curr-bits)
        \0 [(parse-binary literal-bits) bits]
        \1 (recur literal-bits bits)))))

(defn next-with-op
  [op prev bits]
  (let [[value bits] (next-packet bits)]
    [(op prev value) bits]))

(defn next-len
  [op bits]
  (let [[len-bits bits] (split-at 15 bits)
        [sub-bits bits] (split-at (parse-binary len-bits) bits)]
    (loop [[prev sub-bits] (next-packet sub-bits)]
      (if (seq sub-bits)
        (recur (next-with-op op prev sub-bits))
        [prev bits]))))

(defn next-count
  [op bits]
  (let [[count-bits bits] (split-at 11 bits)]
    (loop [remaining (dec (parse-binary count-bits))
           [prev bits] (next-packet bits)]
      (if (pos? remaining)
        (recur (dec remaining) (next-with-op op prev bits))
        [prev bits]))))

(defn next-packet
  [bits]
  (let [[id-bits bits] (split-at 3 (drop 3 bits))
        op (case (parse-binary id-bits)
             0 +
             1 *
             2 min
             3 max
             4 'literal
             5 #(if (> %1 %2) 1 0)
             6 #(if (< %1 %2) 1 0)
             7 #(if (= %1 %2) 1 0))]
    (cond
      (= op 'literal)     (next-literal bits)
      (= (first bits) \0) (next-len op (rest bits))
      (= (first bits) \1) (next-count op (rest bits)))))

(defn eval-packet
  [input]
  (first (next-packet input)))

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

(-> *in* read-input eval-packet println)
