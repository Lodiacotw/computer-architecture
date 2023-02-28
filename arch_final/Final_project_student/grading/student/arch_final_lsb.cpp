#include <iostream>
#include <fstream>
#include <cmath>
#include <list>
#include <utility>
using namespace std;

string reference_list[100];
string hit_or_miss[100];

int main(int argc, char *argv[])
{
    if (argc != 4)
    {
        cout << "Please Input: {your project} cache.org reference.lst index.rpt" << endl;
        return 0;
    }
    string config_file = argv[1];
    string input_file = argv[2];
    string output_file = argv[3];
    fstream file;

    /********************* 開啟cache資訊檔**************************/
    file.open(config_file, ios::in);
    if (!file)
    {
        cerr << "Cannot Open File: " << config_file << endl;
        exit(1);
    }

    string title;
    int data;
    int data_num = 0;
    int data_list[4] = {0};
    while (file >> title >> data)
    {
        data_list[data_num++] = data;
    }
    file.close();

    int address_bits = data_list[0];
    int block_size = data_list[1];
    int cache_sets = data_list[2];
    int associativity = data_list[3];
    int offset_bit_count = log2(block_size);
    int index_bit_count = log2(cache_sets);
    int index_bit[] = {0};
    int tag_bit_count = address_bits - index_bit_count - offset_bit_count;
    for (int i = offset_bit_count, j = 0; j < index_bit_count; i++, j++)
    {
        index_bit[j] = i;
    }

    /********************* 開啟輸入檔案 **************************/
    file.open(input_file, ios::in);
    if (!file)
    {
        cerr << "Cannot Open File: " << input_file << endl;
        exit(1);
    }

    int ref_num = 0;
    int title_count = 0;
    while (file >> title)
    {
        reference_list[ref_num] = title;
        if (title_count == 0)
        {
            file >> title;
            reference_list[ref_num] += " " + title;
            title_count = 1;
        }

        ref_num++;
    }
    file.close();

    /********************* cache LRU模擬 **************************/
    int miss_count = 0;
    // int time = 0;
    int LRU_count[cache_sets][associativity];
    string cache[cache_sets][associativity];
    int Space[cache_sets][associativity];
    for (int i = 0; i < cache_sets; i++)
        for (int j = 0; j < associativity; j++)
            Space[i][j] = 1;

    for (int i = 1; i < ref_num - 1; i++) // ref_num=0為title, 最後一行不需要,所以要扣掉
    {
        string idxString;
        string tag;

        int j = 0;

        for (int k = 0; k < tag_bit_count; j++, k++) //(LSB)從左至右讀取tag bits 字串
        {
            tag += reference_list[i][j];
        }

        for (int k = 0; k < index_bit_count; j++, k++) // 從tag bits的右邊一個bit讀取index字串
        {
            idxString += reference_list[i][j];
        }

        int idx = stoi(idxString, 0, 2); // 將字串轉成10進制

        int hit = 0;
        for (int a = 0; a < associativity; a++) // 進行tag比對,若相等顯示hit
        {
            if (cache[idx][a] == tag) // 若同index下 cache的data=tag時, cache hit
            {
                hit_or_miss[i] = " hit";
                Space[idx][a] = 0;
                hit = 1;
                if (LRU_count[idx][a] == 0) // 若hit到最新的值，則其餘資料時間不用改變
                {
                    continue;
                }
                else
                {
                    for (int h = 0; h < associativity; h++) // 將其餘位置的時間都加一,hit位置設成0
                    {
                        LRU_count[idx][h]++;
                        if (LRU_count[idx][h] >= associativity) // 若位置全佔滿,最久的讀取時間為associativity - 1
                        {
                            LRU_count[idx][h] = associativity - 1;
                        }
                        else if (Space[idx][h] == 1)
                        { // 若位置沒被佔滿,在第h位置時有空間,最久的讀取時間為h - 1
                            for (int k = 0; k < associativity; k++)
                            {
                                if (LRU_count[idx][k] >= h)
                                {
                                    LRU_count[idx][k] = h - 1;
                                }
                            }
                            LRU_count[idx][a] = 0;
                            break;
                        }
                    }
                    LRU_count[idx][a] = 0;
                }

                break;
            }
        }
        if (hit == 1)
        {
            continue; // hit的話會省略以下部分，再跳回本次迴圈
        }

        hit_or_miss[i] = " miss";
        miss_count++;

        for (int a = 0; a < associativity; a++)
        {
            if (Space[idx][a] == 1) // 若 cache miss,先找同index下還有沒有空間 Space = 1(還有空間)
            {
                cache[idx][a] = tag;
                Space[idx][a] = 0; // 把資料存進cache,並把Space = 0(空間被占用)

                for (int h = 0; h < associativity; h++) // 將其餘有值的位置時間都加一,最新資料位置設成0
                {
                    LRU_count[idx][h]++;
                    if (LRU_count[idx][h] >= associativity)
                    {
                        LRU_count[idx][h] = associativity - 1;
                    }
                }
                for (int k = associativity - 1; k > a; k--)
                {
                    LRU_count[idx][k] = 0;
                }

                LRU_count[idx][a] = 0;
                break;
            }
            // 若同個index下cache 最後一筆associativity裡的資料被占據,需用LRU方法覆蓋
            else if (a == associativity - 1 && Space[idx][a] == 0)
            {
                if (LRU_count[idx][a] == associativity - 1) // 找出距離使用時間最長的位置,把它取代
                {
                    cache[idx][a] = tag;
                    Space[idx][a] = 0;
                    for (int h = 0; h < associativity; h++) // 將其餘位置的時間都加一,取代位置設成0
                    {
                        LRU_count[idx][h]++;
                    }
                    LRU_count[idx][a] = 0;
                }
            }
        }
    }

    /********************* 輸出index檔 **************************/
    file.open(output_file, ios::out);
    if (!file)
    {
        cerr << "Cannot Open File: " << output_file << endl;
        exit(1);
    }

    file << "Address bits: " << address_bits << endl;
    file << "Block size: " << block_size << endl;
    file << "Cache sets: " << cache_sets << endl;
    file << "Associativity: " << associativity << endl;
    file << endl;
    file << "Offset bit count: " << offset_bit_count << endl;
    file << "Indexing bit count: " << index_bit_count << endl;
    file << "Indexing bits:";
    for (int i = index_bit_count - 1; i >= 0; i--)
    {
        file << " " << index_bit[i];
    }
    file << endl
         << endl;

    for (int i = 0; i < ref_num; i++)
    {
        file << reference_list[i] << hit_or_miss[i] << endl;
    }
    file << endl;
    file << "Total cache miss count: " << miss_count << endl;
    file.close();
    return 0;
}