using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefWeaponTypeHelper
    {

        public static List<RefWeaponType> GetData()
        {
            /*
            select 'data.Add(new RefFirearmType() { 
            RefFirearmTypeId = ' + convert(varchar(20), RefFirearmTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefFirearmType
            */

            var data = new List<RefWeaponType>();
            data.Add(new RefWeaponType() { RefWeaponTypeId = 1, Code = "Firearm", Description = "Firearm" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 2, Code = "Handgun", Description = "Handgun" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 3, Code = "Shotgun", Description = "Shotgun" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 4, Code = "Rifle", Description = "Rifle" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 5, Code = "OtherFirearm", Description = "Other Firearm" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 6, Code = "Knife", Description = "Knife" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 7, Code = "KnifeLessThanTwoPointFiveInches", Description = "Knife Less Than 2.5 Inches" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 8, Code = "KnifeLessThanThreeInches", Description = "Knife Less Than Three Inches" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 9, Code = "KnifeGreaterThanThreeInches", Description = "Knife Greater Than Three Inches" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 10, Code = "OtherSharpObject", Description = "Other sharp object" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 11, Code = "OtherObject", Description = "Other object" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 12, Code = "Substance", Description = "Substance used as weapon" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 13, Code = "OtherWeapon", Description = "Other weapon" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 14, Code = "None", Description = "None" });
            data.Add(new RefWeaponType() { RefWeaponTypeId = 15, Code = "Unknown", Description = "Unknown weapon" });

            return data;
        }
    }
}
