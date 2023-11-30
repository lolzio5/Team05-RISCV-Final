#include <iostream>

void counter(){
    long counter=100000000;
    while (counter!=0){
        counter=counter-1;
    }
}
void random_counter(){
    bool reg1=1;
    bool reg2=1;
    bool reg3=1;
    bool reg4=0;

    long counter=((((((reg1 << 1) | reg2)<<1)|reg3)<<1)|reg4)*100000000;
    reg1=reg3^reg4;
    while (counter!=0){
        counter=counter-1;
    }
}

int main(int argc, char **argv, char **env) {
    int vbd_value=0;
    while (vbd_value<255){
        std::cout<<vbd_value<<std::endl;
        vbd_value=vbd_value+1;
        counter();
    }
    random_counter();
    vbd_value=0;
    std::cout<<vbd_value<<std::endl;
}