#!/usr/bin/env python3

import sys
import re

#error =

lines = sys.stdin.readlines()

l1 = []
l2 = []
l3 = []
l4 = []
l5 = []
l6 = []
l7 = []
l8 = []
l9 = []
l10 = []
l11 = []
l12 = []
l13 = []
l14 = []
l15 = []
l16 = []
l17 = []
l18 = []
l19 = []
l20 = []


client_2_regex = r"Client_2\( \$C.[0-9], \$E.[0-9], ~ltk.[0-9], \$A.[0-9], server_pk"


lemma = sys.argv[1]

for line in lines:
    num = line.split(":")[0]

    if "~~>" in line:
        l1.append(num)
        continue

    if lemma == "auto_adversaryCannotCompromiseAgressorLTK" or lemma == "auto_adversaryCannotCompromiseNPLTK":
        if " ~ltk" in line:
            l1.append(num)

    elif lemma == "auto_adversaryKnowsOTEEDHSecretAfterReveal":
        if " ~x_0" in line:
            l1.append(num)

    elif lemma == "auto_OTEEsNeverChooseSameSecrets" or lemma == "auto_OTEEChallengeResponseOnlyIfOTEEHello":
        if "OTEE_3" in line or "OTEE_0" in line:
            l1.append(num)

    elif lemma == "auto_adversaryCannotRecoverAggressorDHShare":
        if " ~x_1" in line:
            l1.append(num)

    elif lemma == "auto_AdversaryNeverLearnsS":
        if "~s" in line:
            l1.append(num)

    elif lemma == "auto_DH_source":
        if "splitEqs(0)" in line:
            l1.append(num)
        elif "OTEEIn" in line:
            l2.append(num)

    elif lemma == "auto_adversaryCannotFigureOutMeasurementPositionsBeforeTheMeasurementHappens" or lemma == "auto_adversaryCannotExtractAgentPropertiesBeforeMeasurement":
        if "OTEEMeasure" in line:
            l1.append(num)

    elif lemma == "auto_adversaryCannotFindPropertiesFromAggressor":
        if "Aggressor_0" in line:
            l1.append(num)
        elif " !KU( ~prop )" in line:
            l2.append(num)

    elif lemma == "auto_AdversaryNeverLearnsT":
        if "!KU( ~t" in line:
            l1.append(num)

    elif lemma == "auto_adversaryCannotLearnDeviceDHShareBeforeEnd":
        if "OTEE_3" in line:
            l1.append(num)

    elif lemma == "auto_aggressorDHKeyIsUnique":
        if "splitEqs" in line:
            l1.append(num)
        elif "Aggressor_0(" in line:
            l2.append(num)
        else:
            pass

    elif lemma == "auto_adversaryCannotLearnOTEELtk":
        if "!KU( ~OTEE_ltk )" in line:
            l1.append(num)
        else:
            pass

#    elif lemma == "auto_adversaryCannotLearnDeviceDHShareBeforeMeasurement":
#        if "splitEqs(0)" in line:
#            l1.append(num)
#        elif "OTEE_0(" in line:
#            l2.append(num)
#        elif " !KU( ~x_0" in line:
#            l3.append(num)
#        else:
#            pass

    elif lemma == "auto_adversaryCannotKnowAggressorLtk":
        if "!KU( ~ltk )" in line:
            l1.append(num)
        elif "Aggressor_0" in line:
            l2.append(num)
        else:
            pass

    elif lemma == "auto_twoOTEEsCannotHaveSameShare":
        if "OTEE_0" in line:
            l1.append(num)
        elif "splitEqs(0)" in line:
            l2.append(num)
        elif "OTEEIn" in line and "#i" in line:
            l3.append(num)
        elif " !KU( DHE^" in line:
            l4.append(num)
        elif "OTEE_3(" in line:
            l5.append(num)
        elif " !KU( x^(x.1" in line:
            l7.append(num)
        elif " !KU( x^inv" in line:
            l7.append(num)
        elif " !KU( x.1^" in line:
            l7.append(num)
        elif " !KU( 'g'^(~x" in line:
            l7.append(num)
        elif "OTEEIn" in line and "#j" in line:
            l8.append(num)
        elif " !KU( X_11^" in line:
            l9.append(num)
        elif " !KU( X_11_2^" in line:
            l9.append(num)
        elif "splitEqs(1)" in line:
            l10.append(num)
        elif " !KU( sign(" in line:
            l13.append(num)
        elif " !KU( senc(sign" in line:
            l14.append(num)
        else:
            pass

    elif lemma == "auto_adversaryCannotKnowDHEOfHonestOTEEAndThreatAgent":
        if "Aggressor_0" in line:
            l1.append(num)
        elif "OTEE_0" in line:
            l2.append(num)
        elif " !KU( pk(x) )" in line:
            l2.append(num)
        elif "OTEEIn" in line:
            l3.append(num)
        elif " !KU( senc(sign" in line:
            l4.append(num)
        elif " !KU( 'g'^" in line and "*" in line and line.count('~') >= 2:
            l5.append(num)
        elif " !KU( sign(" in line:
            l6.append(num)
        elif " !KU( ~OTEE_ltk )" in line:
            l7.append(num)
        elif "splitEqs(" in line:
            l8.append(num)
        elif " !KU( 'g'^" in line and "*" in line and line.count('~') >= 1:
            l9.append(num)
        elif " !KU( 'g'^" in line and "*" in line:
            l10.append(num)
        else:
            pass

    elif lemma == "auto_adversaryCanKnowDHEOfHonestOTEEAndThreatAgentAfterReveal":
        if "Aggressor_0" in line:
            l1.append(num)
        elif "OTEESession" in line:
            l2.append(num)
        elif "OTEE_0" in line:
            l3.append(num)
        elif "OTEEIn" in line:
            l4.append(num)
        elif " !KU( senc(sign" in line:
            l5.append(num)
        elif " !KU( 'g'^" in line and "*" in line:
            if line.count('~') == 0:
                l7.append(num)
            else:
                l6.append(num)
        elif " !KU( sign(" in line:
            l7.append(num)
        elif " !KU( pk(x)" in line:
            l8.append(num)
        elif " !KU( ~OTEE_ltk" in line:
            l9.append(num)
        elif "splitEqs(" in line:
            l10.append(num)

    elif lemma == "auto_adversaryMustKnowOTEEShare":
        if "OTEE_0" in line:
            l1.append(num)
        elif "OTEEIn" in line:
            l2.append(num)

    elif lemma == "auto_ifOTEEConnectsToServerThenShareMustBeOutputByTheServer":
        if "OTEEIn" in line:
            l1.append(num)
        elif "!KU( senc(sign" in line:
            l2.append(num)
        elif "!KU( sign(" in line:
            l3.append(num)
        elif "!KU( ~ltk )" in line:
            l4.append(num)
        else:
            pass

    elif lemma == "auto_ifServerAndOTEEHaveSameKeyThenTheyCommunicated":
        if "OTEE_0" in line:
            l1.append(num)
        elif "senc(sign(" in line:
            l2.append(num)
        elif "!KU( derive_secret(" in line:
            l3.append(num)
        elif "splitEqs" in line:
            l4.append(num)
        elif "!KU( 'g'^(~x*~x_1)" in line:
            l5.append(num)
        elif True:
            pass
        elif "~ltk" in line:
            l1.append(num)
        elif "OTEE_0" in line:
            l2.append(num)
        elif "OTEEIn" in line:
            l3.append(num)
        elif "!KU( senc(sign" in line:
            l4.append(num)
        elif "!KU( sign(" in line:
            l5.append(num)
        elif "splitEqs(0)" in line:
            l6.append(num)
        elif "splitEqs(1)" in line:
            l7.append(num)
        elif "~x_0" in line and "~x_1" in line and not "¬" in line and not "hmac" in line:
            l8.append(num)
        elif "OTEE_3" in line:
            l9.append(num)
        elif "!KU( derive_secret" in line and "'s_hs_traffic'" in line:
            l10.append(num)
        elif "!KU( 'g'^x.1" in line:
            l11.append(num)
        elif "inv(~x_1)" in line:
            l12.append(num)
        elif "inv((~x_1" in line:
            l13.append(num)
        elif True:
            pass

    elif lemma == "auto_OTEEOrder":
        if "OTEESession" in line:
            l1.append(num)
        elif "OTEE_0" in line:
            l2.append(num)
        elif "OTEE_3" in line:
            l3.append(num)
        else:
            pass

    elif lemma == "auto_AdversaryKnowsDHEOnlyIfItKnowsTheShare":
        if "OTEE_0( ~tee_id, $OTEE, 'g', 'g2', $D, ~u, n_0, ~x_0," in line:
            l1.append(num)
        elif " !KU( senc(sign(<" in line and "derive_secret('g'^(~x_0*~x_1)" in line:
            l1.append(num)
        elif " derive_secret('g'^(~x_0*~x_1.1)," in line:
            l2.append(num)
        elif " !KU( 'g'^(~x_0*~x_1)" in line:
            l4.append(num)
        elif " !KU( 'g'^(~x_0*~u.1)" in line:
            l4.append(num)
        elif " !KU( ~t.1 )" in line:
            l2.append(num)
        elif " !KU( ~u.1 )" in line:
            l2.append(num)
        elif "splitEqs(" in line:
            l3.append(num)
        elif " !KU( derive_secret(" in line:
            l3.append(num)
        elif " !KU( 'g'^(~x_0*~x_1)" in line:
            l3.append(num)
        elif " !KU( senc(sign" in line:
            l4.append(num)
        elif " !KU( sign(<" in line:
            l5.append(num)
        elif " !KU( ~ltk )" in line:
            l1.append(num)
        elif "!KU( 'g'^(~x" in line or "!KU( 'g'^(~u" in line:
            l3.append(num)
        elif " !KU( 'g'^(~x_0.1*~x_1.1)" in line:
            l4.append(num)
        elif " !KU( 'g'^(x.1*inv(~x_0))" in line:
            l5.append(num)
        elif " !KU( 'g'^inv((~x_0*x.1))" in line:
            l6.append(num)
        elif " !KU( 'g'^(x.1*inv((~x_0*x.2)))" in line:
            l7.append(num)
        else:
            pass

    elif lemma == "auto_ifServerAndOTEEDeriveSameKeyTheAdversaryCannotLearnIt" or lemma == "auto_ifServerAndOTEEDeriveSameKeyTheAdversaryCannotLearnServerHandshakeSecret" or lemma == "auto_ifServerAndOTEEDeriveSameKeyTheAdversaryCannotLearnClientHandshakeSecret":
        if "OTEE_0" in line:
            l2.append(num)
        elif "senc(sign(" in line:
            l2.append(num)
        elif "!KU( derive_secret(" in line:
            l3.append(num)
        elif "splitEqs" in line:
            l1.append(num)
        elif "!KU( 'g'^(~x*~x_1)" in line:
            l5.append(num)
        elif "!KU( 'g'^(~x_0*~x_1)" in line:
            l6.append(num)
        else:
            pass

    elif lemma == "auto_OTEEExponentsLemma":
        if "OTEE_0" in line:
            l1.append(num)
        elif "senc(sign" in line:
            l2.append(num)
        elif "senc(hmac" in line:
            l3.append(num)
        elif "sign(<" in line:
            l4.append(num)
        elif "splitEqs(" in line:
            l5.append(num)
        elif "!KU( ~u" in line:
            l6.append(num)
        else:
            pass

    elif lemma == "auto_AdversaryNeverLearnsG2InvTBeforeT":
        if "inv(~t)" in line:
            l1.append(num)
        else:
            pass

    elif lemma == "auto_ImpossibleBeforeXCH" or lemma == "auto_ImpossibleBeforeUCH":
        if "ImpossibleBeforeXCH" in line or "ImpossibleBeforeUCH" in line:
            l1.append(num)
        elif "!KU( 'g'^~x_0 )" in line:
            l2.append(num)
        elif "splitEqs(" in line:
            l3.append(num)
        elif "!KU( ~u )" in line:
            l4.append(num)
        elif "!KU( 'g2'^~u )" in line:
            l5.append(num)
        else:
            pass

    elif lemma == "auto_AdversaryNeverLearnsG2TBeforeT":
        if "!KU( 'g2'^~t" in line:
            l1.append(num)
        elif "splitEqs(" in line:
            l2.append(num)
        else:
            pass

    elif lemma == "auto_ImpossibleBeforeXCH":
        if "!KU( 'g'^~x_0" in line:
            l1.append(num)
        elif "splitEqs(" in line:
            l2.append(num)
        else:
            pass

    elif lemma == "auto_ImpossibleBeforeUCH":
        if "splitEqs(" in line:
            l1.append(num)
        else:
            pass

    elif lemma == "auto_twoOTEEsCannotHaveSameDHE" or lemma == "auto_twoAggrCannotHaveSameDHE":
        if "OTEE_0" in line:
            l1.append(num)
        elif "splitEqs(0)" in line:
            l2.append(num)
        elif "OTEEIn" in line:
            l3.append(num)
        elif "OTEE_3(" in line:
            l5.append(num)
        elif "splitEqs(" in line:
            l7.append(num)
        elif "OTEEIn" in line and "#j" in line:
            l8.append(num)
        elif "!KU( 'g'^(~x*~x_1) )" in line:
            l9.append(num)
        elif "!KU( 'g'^(~x*~x_0)" in line:
            l9.append(num)
        elif " !KU( X_11^" in line:
            l9.append(num)
        elif " !KU( X_11_2^" in line:
            l9.append(num)
        elif " !KU( DHE^" in line:
            l9.append(num)
        elif " !KU( sign(" in line:
            l13.append(num)
        elif " !KU( senc(sign" in line:
            l14.append(num)
        elif " !KU( derive_secret" in line:
            l15.append(num)
        elif " splitEqs(1)" in line:
            l16.append(num)
        elif " !KU( ~ltk )" in line:
            l17.append(num)
        elif " !KU( 'g'^(~x" in line:
            l17.append(num)
        elif " !KU( x.1^" in line:
            l17.append(num)
        else:
            pass

#    elif lemma == "auto_adversaryCannotLearnoTEEDHShareBeforeOTEEStarts":
#        if True:
#            pass

    elif lemma == "auto_adversaryCannotKnowMeasurementPositionBeforeMeasurement":
        if "Aggressor_0" in line:
            l1.append(num)
        elif "splitEqs(" in line:
            l1.append(num)
        elif " !KU( ~x )" in line:
            l1.append(num)
        elif "OTEEMeasure" in line:
            l2.append(num)
        elif "OTEE_2" in line:
            l3.append(num)
        elif " !KU( senc(sign(" in line:
            l4.append(num)

        elif " !KU( 'g'" in line and "inv(" in line:
            l4.append(num)

        elif " !KU( select('g'^" in line:
            l5.append(num)
        elif " !KU( 'g'^(~x_0*~x_1)" in line:
            l6.append(num)
        elif " OTEE_3" in line:
            l7.append(num)
        elif " !KU( sign(<<" in line:
            l8.append(num)
        elif " !KU( 'g'^inv" in line:
            l9.append(num)
        elif " !KU( select('g'^(~x*~x_1)) )" in line:
            l10.append(num)
        elif " !KU( 'g'^(~x*~x_1)" in line:
            l11.append(num)
        else:
            pass

    elif lemma == "auto_TheMeasurementPositionIsUnique":
        if "OTEEPosition" in line:
            l1.append(num)
        elif "OTEE_2" in line:
            l2.append(num)
        else:
            pass

    elif lemma == "auto_acceptedVerificationOnlyIfCorrectOTEEWasRunning":
        if "!NP_Ltk" in line:
            l1.append(num)
        elif "!NP_Pk" in line:
            l2.append(num)
        elif "Aggressor_1(" in line:
            l3.append(num)
        elif "!KU( senc(<y" in line:
            l4.append(num)
        elif "OTEE_3" in line:
            l5.append(num)
        elif "!KU( sign(<$OTEE" in line:
            l6.append(num)
        elif "splitEqs(0)" in line:
            l7.append(num)
        elif "!KU( sign(<y" in line:
            l8.append(num)
        elif "!KU( ~OTEE_ltk" in line:
            l9.append(num)
        else:
            pass

    elif lemma == "auto_acceptVerificationFromOTEEImpliesSharedSecret":
        if "simplify" in line:
            l1.append(num)
        elif "Aggressor_1" in line:
            l2.append(num)
        elif "!KU( 'g'^(x" in line:
            l3.append(num)
        elif "!NP_Pk(" in line:
            l3.append(num)
        elif "Device_2" in line:
            l4.append(num)
        elif "!KU( ~OTEE_ltk" in line:
            l4.append(num)
        elif "~ltk" in line:
            l5.append(num)
        elif "OTEE" in line:
            l6.append(num)
        else:
            pass

    elif lemma == "auto_adversaryCannotKnowEnclaveShareBeforeReveal":
        if "OTEE_Ltk" in line:
            l2.append(num)
        elif "OTEE_3" in line:
            l1.append(num)
        elif "!KU( ~x_0" in line:
            l3.append(num)
        else:
            pass

    elif lemma == "auto_adversaryCannotKnowDHEBeforeReveal":
        if "!KU( 'g'^(~x*~x_1)" in line:
            l1.append(num)
        elif "OTEE_3( ~tee_id," in line:
            l2.append(num)
        elif "!KU( 'g'^(~x_0" in line:
            l2.append(num)
        elif "splitEqs" in line:
            l3.append(num)
        elif "!KU( senc(sign(" in line or "!KU( senc(hmac(" in line or "OTEE_" in line or "!KU( add(" in line:
            l4.append(num)
        elif "!KU( sign(" in line and "~ltk" in line:
            l5.append(num)
        elif "!KU( ~x" in line:
            l6.append(num)
        else:
            pass

    elif lemma == "auto_token_integrity":
        if "!NP_Pk" in line:
            l1.append(num)
        elif "!KU( sign(<$otee" in line:
            l2.append(num)

    elif lemma == "auto_measurementPositionIsUnique":
        if "simplify" in line:
            l1.append(num)
        elif "OTEE_2" in line:
            l2.append(num)
        else:
            pass

    elif lemma == "auto_succeessfultVerificationImpliesEnclaveMeasuredCorrectProperties":
        if "simplify" in line:
            l1.append(num)
        elif "NP_Pk" in line:
            l2.append(num)
        elif "!KU( sign(<$otee" in line:
            l3.append(num)
        elif "Aggressor_1" in line:
            l4.append(num)
        elif "!KU( pk(~OTEE" in line:
            l5.append(num)
        elif "splitEqs(0)" in line:
            l6.append(num)
        elif "OTEE_2(" in line:
            l6.append(num)
        elif "!KU( 'g'^" in line and "inv" in line:
            l1.append(num)
        elif "!KU( senc(hmac" in line:
            l7.append(num)
        elif "!KU( derive_secret('g'" in line:
            l8.append(num)
        elif "!KU( 'g'^(" in line:
            l9.append(num)
        elif " !KU( senc(<" in line:
            l10.append(num)
        elif " !KU( sign(" in line:
            l10.append(num)
        elif " !KU( select('g'" in line:
            l11.append(num)
        elif " !KU( sign(" in line and "~OTEE_ltk" in line:
            l12.append(num)
        elif "splitEqs(8)" in line:
            l13.append(num)
        elif "splitEqs(9)" in line or "splitEqs(10)" in line:
            l14.append(num)
        elif " !KU( 'g'^(" in line:
            l15.append(num)
        elif "splitEqs" in line:
            l18.append(num)
        elif "!KU( ~ch_prop )" in line:
            l19.append(num)
        else:
            pass

    elif lemma == "auto_binding_integrity":
        if "simplify" in line:
            l1.append(num)
        elif "Aggressor_1(" in line:
            l2.append(num)
        elif "NP_Pk( $NP, pk(x" in line:
            l3.append(num)
        elif "!KU( ~OTEE_ltk" in line:
            l4.append(num)
        elif "~OTEE)" in line:
            l5.append(num)
        elif "sign(<$OTEE, pk" in line:
            l6.append(num)
        elif "!KU( pk(~OTEE_ltk" in line:
            l7.append(num)
        elif "splitEqs(0)" in line:
            l8.append(num)
        elif " !KU( 'g'^" in line and "inv" in line:
            l9.append(num)
        elif " !KU( senc(" in line and "~OTEE_ltk" in line:
            l10.append(num)
        elif "splitEqs" in line:
            l11.append(num)
        elif " !KU( ~prop )" in line:
            l12.append(num)
        elif " !KU( read(select('g'" in line:
            l13.append(num)
        elif " !KU( select('g'" in line:
            l14.append(num)
        elif " !KU( sign(" in line and "~OTEE_ltk" in line:
            l15.append(num)
        elif " !KU( senc(hmac" in line:
            l16.append(num)
        elif " !KU( ~ch_prop )" in line:
            l17.append(num)
        else:
            pass

    elif lemma == "auto_binding_integrity_2":
        if "simplify" in line:
            l1.append(num)
        elif "Aggressor_1(" in line:
            l2.append(num)
        elif "NP_Pk( $NP, pk(x" in line:
            l3.append(num)
        elif "!KU( ~OTEE_ltk" in line:
            l4.append(num)
        elif "sign(<$OTEE, pk" in line:
            l6.append(num)
        elif "!KU( pk(~OTEE_ltk" in line:
            l7.append(num)
        elif "!KU( senc(<y" in line:
            l8.append(num)
        elif "splitEqs(2)" in line:
            l9.append(num)
        elif "Aggressor_0" in line:
            l14.append(num)
        elif "!KU( read(select" in line:
            l10.append(num)
        elif "splitEqs" in line:
            l13.append(num)
        elif "!KU( sign(<y" in line:
            l11.append(num)
        elif " !KU( measure(select" in line:
            l11.append(num)
        elif " !KU( select('g'^" in line:
            l12.append(num)
        elif " !KU( 'g'^(~x_0" in line:
            l13.append(num)
        elif " !KU( ~x_0" in line:
            l14.append(num)
        elif "~ltk)" in line:
            l15.append(num)
        elif "~prop" in line:
            l16.append(num)
        elif "!NP_Pk(" in line:
            l17.append(num)

#        elif "senc(sign(<" in line:
#            l12.append(num)
#        elif "select" in line:
#            l13.append(num)
#        elif "!KU( 'g'^" in line and "x_0" in line and "x_1" in line:
#            l14.append(num)
#        elif "!KU( ~x_0" in line:
#            l15.append(num)
        elif True:
            pass

    elif lemma == "executable":
        if "Aggressor_1" in line:
            l1.append(num)
        elif "OTEE_ltk" in line:
            l1.append(num)
        elif "NP_Pk" in line:
            l2.append(num)
        elif "!KU( sign(" in line:
            l3.append(num)
        elif "!KU( senc(" in line:
            l4.append(num)
        elif "Device_2" in line:
            l5.append(num)
        elif " !KU( v(" in line:
            l6.append(num)
        elif "pk" in line:
            l7.append(num)
        elif "'g'^" in line:
            l8.append(num)
        elif "~u" in line:
            l9.append(num)
        else:
            pass

    else:
        exit(0)


ranked = l1 + l2 + l3 + l4 + l5 + l6 + l7 + l8 + l9 + l10 + l11 + l12 + l13 + l14 + l15 + l16 + l17 + l18 + l19 + l20


#if len(ranked) == 0 and len(lines) > 0:
#    error =
#    with open('pomoc.txt', 'w') as f:
#        f.write(str(lines))
#    raise Exception('Oracle found no good choice')

for i in ranked:
    print(i)
