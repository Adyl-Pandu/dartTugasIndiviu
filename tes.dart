// ---------- DATA ----------
const String pinBenar = '945313';
int saldo = 1000000;
int sisaLimit = 2000000;
int pinSalah = 0;
bool diblokir = false;

// ---------- VALIDATION ----------
bool cekPin(String input) {
  if (input == pinBenar) {
    pinSalah = 0;
    print("masuk ke atm");
    return true;
  }
  pinSalah++;

  if (pinSalah >= 3) {
    diblokir = true;
  }
  return false;
}

bool limitTerlewati(int total) {
  return total > sisaLimit;
}
bool saldoKurang(int total) {
  return saldo < total;
}

// ---------- ALGORITHM ----------
String bayar(int total, String input) {
  if (diblokir) {
    return 'Gagal: akun diblokir';
  }
  if (!cekPin(input)) {
    if (diblokir) {
      return 'Gagal: PIN salah (3/3), akun diblokir';
    }
    return 'Gagal: PIN salah ($pinSalah/3)';
  }
  if (limitTerlewati(total)) {
    return 'Gagal: melebihi limit harian';
  }
  if (saldoKurang(total)) {
    return 'Gagal: saldo tidak cukup';
  }
  saldo -= total;
  sisaLimit -= total;
  return 'SUKSES: saldo Rp$saldo, sisa limit Rp$sisaLimit';
}

// ---------- TEST SCENARIO ----------
void main() {
  // Skenario 1
  print(bayar(500000, '945313'));
  // Skenario 2
  print(bayar(2000000, '111111'));
  // Skenario 3
  print(bayar(2500000, '945313'));
  // Skenario 4
  print(bayar(1500000, '945313'));
  // Skenario 5
  print(bayar(1500000, '112233'));
  // Skenario 6
  print(bayar(1500000, '112233'));
  // Skenario 7
  print(bayar(1500000, '112233'));
  // Skenario 8
  print(bayar(10000, '945313'));
}