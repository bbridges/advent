#include <iostream>
#include <list>

int main()
{
  std::list<uint64_t> stones;

  uint64_t num;
  while (std::cin >> num)
    stones.push_back(num);

  for (int i = 0; i < 25; i++)
  {
    for (auto it = stones.begin(); it != stones.end(); it++)
    {
      uint64_t &stone = *it;

      if (stone == 0)
      {
        stone = 1;
        continue;
      }

      int digits = 0;
      for (uint64_t i = stone; i != 0; i /= 10)
        digits++;

      if (digits == 0 || digits % 2 == 1)
      {
        stone *= 2024;
        continue;
      }

      int modulus = 1;
      for (int i = 0; i < digits / 2; i++)
        modulus *= 10;

      uint64_t left = stone / modulus, right = stone % modulus;

      stone = right;
      stones.insert(it, left);
    }
  }

  std::cout << stones.size() << std::endl;
}
