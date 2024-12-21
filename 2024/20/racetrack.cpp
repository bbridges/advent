#include <iostream>

int main()
{
  std::vector<std::string> track;

  std::string line;
  getline(std::cin, line);

  track.push_back(std::string(line.size() + 2, '#'));

  do
  {
    line.insert(0, "#");
    line.push_back('#');

    track.push_back(line);
  } while (getline(std::cin, line));

  track.push_back(std::string(line.size(), '#'));

  size_t w = track.size(), h = track[0].size(), start_x, start_y, end_x, end_y;

  for (size_t i = 0; i < w; i++)
    for (size_t j = 0; j < h; j++)
      if (track[i][j] == 'S')
        start_x = i, start_y = j;
      else if (track[i][j] == 'E')
        end_x = i, end_y = j;

  track[end_x][end_y] = '.';
  track[start_x][start_y] = ' ';

  size_t x = start_x, y = start_y;
  std::vector<std::vector<int>> times(w, std::vector<int>(h, INT_MIN));

  times[start_x][start_y] = 0;
  int time = 0;

  const int min_cheat = 100;
  int cheats = 0;

  while (x != end_x || y != end_y)
  {
    if (track[x + 1][y] == '.')
      x++;
    else if (track[x - 1][y] == '.')
      x--;
    else if (track[x][y + 1] == '.')
      y++;
    else if (track[x][y - 1] == '.')
      y--;

    track[x][y] = ' ';
    times[x][y] = ++time;

    for (int dir = 0; dir < 4; dir++)
      if (time - times[x + (2 - dir) % 2 * 2][y + (dir - 1) % 2 * 2] >= min_cheat + 2)
        cheats++;

    for (std::ptrdiff_t dx = -1; dx <= 1; dx += 2)
      for (std::ptrdiff_t dy = -1; dy <= 1; dy += 2)
        if (time - times[x + dx][y + dy] >= min_cheat + 2)
          cheats++;
  }

  std::cout << cheats << std::endl;
}
