# Hardware Notes

https://linux-hardware.org/?probe=3825190816

## CPU

PCIe 3 Lanes: 16

[Intel Xeon W-1290P](https://ark.intel.com/content/www/us/en/ark/products/199336/intel-xeon-w-1290p-processor-20m-cache-3-70-ghz.html),
similar to [Intel Core i9-10900K](https://ark.intel.com/content/www/us/en/ark/products/199332/intel-core-i9-10900k-processor-20m-cache-up-to-5-30-ghz.html)

Bought on 2021-01-18 for 576.9 EUR.

Merchant: ALTERNATE GmbH
Auftrag: 273501568
Rechnungsnummer: 472555694 

## Mainboard

https://www.asus.com/Motherboards-Components/Motherboards/Workstation/Pro-WS-W480-ACE/

https://www.anandtech.com/show/15863/the-intel-w480-motherboard-overview-lga1200-for-xeon-w-1200/4

Bought on 2021-01-18 for 321.66 EUR.

Merchant: Lemon Technologies GmbH
Auftrag: 786919
Merchant Article Number: M11YLQWL

### Chipset

PCIe Lanes: 24

https://ark.intel.com/content/www/us/en/ark/products/201910/intel-w480-chipset.html

### Networking

```
Intel Ethernet Controller I225-LM (rev 01)
PCI Bus Address: 6e:00.0
Logical Name: enp110s0
MAC: 24:4b:fe:45:16:4c

https://ark.intel.com/content/www/us/en/ark/products/184675/intel-ethernet-controller-i225-lm.html
```

The port physically located towards the "top"/"left" of the I/O panel,
close to video.

```
Realtek RTL8111/8168/8411 (rev 1a)
PCI Bus Address: 6f:00.1
Logical Name: enp111s0f1
MAC: 24:4b:fe:45:16:4d

https://www.realtek.com/en/products/communications-network-ics/item/rtl8111g
```

The port is physically located towards the "bottom"/"right" of the I/O panel,
close to audio.

### Manual

https://gzhls.at/blob/ldb/3/0/e/3/70f7a60c1be53d69d01479d3a16df7ff955b.pdf

## Memory

Kingston Server Premier DIMM 32GB, DDR4-2933, CL21-21-21, ECC (KSM29ED8/32ME) 

http://www.kingston.com/dataSheets/KSM29ED8_32ME.pdf

Overclock of very similar (DDR4-3200 version) memory: https://www.reddit.com/r/Amd/comments/lf3i6b/overclocked_ecc_memory_with_a_5900x_my_results/

Bought on 2021-01-18 for 297.54 EUR total (148.77EUR/module, or 4.65EUR/GB).

Merchant: Lemon Technologies GmbH
Auftrag: 786919
Merchant Article Number: M12YG7ML

## SSD

https://www.samsung.com/semiconductor/minisite/ssd/product/consumer/970evoplus/

https://s3.ap-northeast-2.amazonaws.com/global.semi.static/Samsung_NVMe_SSD_970_EVO_Plus_Data_Sheet_Rev-2-0.pdf

Bought on 2021-01-18 for 317.51 EUR.

Merchant: Lemon Technologies GmbH
Auftrag: 786919
Merchant Article Number: MVIY6YL

## Replacement Criteria

 * ATX 12VO
 * Silent
 * DDR5 with ECC
 * PCIe 5
 * USB 4
 * Intel [Raptor Lake](https://en.wikipedia.org/wiki/Raptor_Lake) or better

[ECC support for Alder Lake with Intel W680](https://www.anandtech.com/show/17308/)

