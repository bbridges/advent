#include <iostream>
#include <map>

int main()
{
  std::map<uint64_t, uint64_t> stones, stones_prev;
  auto add_stones = [](std::map<uint64_t, uint64_t> &stones, uint64_t stone, uint64_t count)
  {
    if (stones.contains(stone))
      stones[stone] += count;
    else
      stones[stone] = count;
  };

  uint64_t num;
  while (std::cin >> num)
    add_stones(stones, num, 1);

  for (int i = 0; i < 75; i++)
  {
    swap(stones, stones_prev);
    stones.clear();

    for (auto &[stone, count] : stones_prev)
    {
      if (stone == 0)
      {
        add_stones(stones, 1, count);
        continue;
      }

      int digits = 0;
      for (uint64_t i = stone; i != 0; i /= 10)
        digits++;

      if (digits == 0 || digits % 2 == 1)
      {
        add_stones(stones, stone * 2024, count);
        continue;
      }

      int modulus = 1;
      for (int i = 0; i < digits / 2; i++)
        modulus *= 10;

      add_stones(stones, stone / modulus, count);
      add_stones(stones, stone % modulus, count);
    }
  }

  uint64_t sum = 0;
  for (auto &[_, count] : stones)
    sum += count;

  std::cout << sum << std::endl;
}
