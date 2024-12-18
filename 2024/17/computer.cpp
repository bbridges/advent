#include <iostream>
#include <sstream>

std::string run(size_t a, size_t b, size_t c, const std::vector<size_t> program)
{
  std::ostringstream os;
  size_t i = 0;

  auto combo = [&](size_t v)
  {
    if (v == 4)
      return a;
    else if (v == 5)
      return b;
    else if (v == 6)
      return c;
    else
      return v;
  };

  while (true)
  {
    size_t instruction = program[i], operand = program[i + 1];

    switch (instruction)
    {
    case 0: // adv
      a = a >> combo(operand);
      break;
    case 1: // bxl
      b = b ^ operand;
      break;
    case 2: // bst
      b = combo(operand) % 8;
      break;
    case 3: // jnz
      if (a != 0)
        i = operand - 2;
      else if (i == program.size() - 2)
        return os.str().substr(1);
      break;
    case 4: // bxc
      b = b ^ c;
      break;
    case 5: // out
      os << ',' << combo(operand) % 8;
      break;
    case 6: // bdv
      b = a >> combo(operand);
      break;
    case 7: // cdv
      c = a >> combo(operand);
      break;
    }

    i += 2;
  }
}

int main()
{
  size_t a, b, c;
  std::vector<size_t> program;

  std::string line;

  std::getline(std::cin, line);
  a = std::stol(line.substr(12));

  std::getline(std::cin, line);
  b = std::stol(line.substr(12));

  std::getline(std::cin, line);
  c = std::stol(line.substr(12));

  std::getline(std::cin, line);
  std::getline(std::cin, line);
  for (size_t i = 9; i < line.size(); i += 2)
    program.push_back(line[i] - '0');

  std::cout << run(a, b, c, program) << std::endl;
}
