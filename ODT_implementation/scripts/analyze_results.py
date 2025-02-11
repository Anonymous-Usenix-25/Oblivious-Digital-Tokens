#!/bin/python

import csv
import statistics


ODT_client_heartbeat_ODT_server = []
ODT_client_handshake_ODT_server = []
with open('results/ODT_client_ODT_server.txt') as csvfile:
    filereader = csv.reader(csvfile, delimiter=',')
    for row in filereader:
        ODT_client_heartbeat_ODT_server.append(float(row[0]))
        ODT_client_handshake_ODT_server.append(float(row[1]))


ODT_client_heartbeat_OpenSSL_server = []
ODT_client_handshake_OpenSSL_server = []
with open('results/ODT_client_OpenSSL_server.txt') as csvfile:
    filereader = csv.reader(csvfile, delimiter=',')
    for row in filereader:
        ODT_client_heartbeat_OpenSSL_server.append(float(row[0]))
        ODT_client_handshake_OpenSSL_server.append(float(row[1]))


OpenSSL_client_ODT_server = []
with open('results/OpenSSL_client_ODT_server.txt') as csvfile:
    filereader = csv.reader(csvfile, delimiter=',')
    for row in filereader:
        OpenSSL_client_ODT_server.append(float(row[0]))


OpenSSL_client_OpenSSL_server = []
with open('results/OpenSSL_client_OpenSSL_server.txt') as csvfile:
    filereader = csv.reader(csvfile, delimiter=',')
    for row in filereader:
        OpenSSL_client_OpenSSL_server.append(float(row[0]))


OpenSSL_server_handshake = []
with open('results/OpenSSL_server_handshake.txt') as csvfile:
    filereader = csv.reader(csvfile, delimiter=',')
    for row in filereader:
        OpenSSL_server_handshake.append(float(row[0]))


ODT_server_handshake = []
with open('results/ODT_server.txt') as csvfile:
    filereader = csv.reader(csvfile, delimiter=',')
    for row in filereader:
        ODT_server_handshake.append(float(row[0]))


ODT_server_nonce_generation = []
ODT_server_elligator_encoding = []
ODT_server_calculate_v = []

with open('results/ODT_server_ODT_generation.txt') as csvfile:
    filereader = csv.reader(csvfile, delimiter=',')
    for row in filereader:
        ODT_server_nonce_generation.append(float(row[0]))
        ODT_server_elligator_encoding.append(float(row[1]))
        ODT_server_calculate_v.append(ODT_server_nonce_generation[-1] - ODT_server_elligator_encoding[-1])


def mean_and_stdev(data):
    return str(round(statistics.mean(data) * 1000, 2)) + " ± " + str(round(statistics.stdev(data) * 1000, 2))


print("Table 2:")
print("ODT Server (overall cost)    ", mean_and_stdev(ODT_server_handshake))
print("  (a) PPET commitment         ", mean_and_stdev(ODT_server_calculate_v))
print("  (b) Elligator decoding      ", mean_and_stdev(ODT_server_elligator_encoding))
print("OpenSSL Server                ", mean_and_stdev(OpenSSL_server_handshake))

print()
print("Table 3:")
print("                ODT server       OpenSSLServer")
print("O-TEE          ", mean_and_stdev(ODT_client_handshake_ODT_server), "     ", mean_and_stdev(ODT_client_handshake_OpenSSL_server))
print("OpenSSL Client   ", mean_and_stdev(OpenSSL_client_ODT_server), "       ", mean_and_stdev(OpenSSL_client_OpenSSL_server))
