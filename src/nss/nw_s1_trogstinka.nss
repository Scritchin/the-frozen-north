//::///////////////////////////////////////////////
//:: Aura of Troglodyte Stench On Enter
//:: nw_s1_trogstinkA.nss
//:: Copyright (c) 2004 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Objects entering the Stench must make a fortitude
    saving throw (DC 13) or suffer 1D6 points of
    Strength Ability Damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Craig Welburn
//:: Created On: Nov 6, 2004
//:://////////////////////////////////////////////
/*
Patch 1.70

- alignment immune creatures were ommited
- was missing immunity feedback
*/

#include "x0_i0_spells"

void main()
{
    // Declare major variables
    object oTarget = GetEnteringObject();
    object oSource = GetAreaOfEffectCreator();

    // Declare all the required effects
    effect eVis1;
    effect eVis2;
    effect eStrenghDrain;

    if(!GetHasSpellEffect(SPELLABILITY_TROGLODYTE_STENCH, oTarget))
    {
        // Is the target a valid creature
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oSource))
        {
            // Notify the target that they are being attacked
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, AOE_MOB_TROGLODYTE_STENCH));

            // Prepare the visual effect for the casting and saving throw
            eVis1 = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
            eVis2 = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);

            // Create the 1d6 strength reduction effect
            // and make it supernatural so it can be dispelled
            eStrenghDrain = EffectAbilityDecrease(ABILITY_STRENGTH, d6());
            eStrenghDrain = SupernaturalEffect(eStrenghDrain);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);

            // Make a Fortitude saving throw, DC 13 and apply the effect if it fails
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, 13, SAVING_THROW_TYPE_POISON, oSource))
            {
                if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON, oSource))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStrenghDrain, oTarget, RoundsToSeconds(10));
                }
                else
                {
                    //engine workaround to get proper immunity feedback
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectPoison(POISON_ETTERCAP_VENOM),oTarget);
                }
            }
        }
    }
}
