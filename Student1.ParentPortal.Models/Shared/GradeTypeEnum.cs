using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class GradeTypeEnum : Enumeration<GradeTypeEnum>
    {
        public static readonly GradeTypeEnum FirstGrade    = new GradeTypeEnum(1, "First Grade");
        public static readonly GradeTypeEnum SecondGrade   = new GradeTypeEnum(2, "Second Grade");
        public static readonly GradeTypeEnum ThirdGrade    = new GradeTypeEnum(3, "Third Grade");
        public static readonly GradeTypeEnum FourthGrade   = new GradeTypeEnum(4, "Fourth Grade");
        public static readonly GradeTypeEnum FifthGrade    = new GradeTypeEnum(5, "Fifth Grade");
        public static readonly GradeTypeEnum SixthGrade    = new GradeTypeEnum(6, "Sixth Grade");
        public static readonly GradeTypeEnum SeventhGrade  = new GradeTypeEnum(7, "Seventh Grade");
        public static readonly GradeTypeEnum EighthGrade   = new GradeTypeEnum(8, "Eighth Grade");
        public static readonly GradeTypeEnum NinthGrade    = new GradeTypeEnum(9, "Ninth Grade");
        public static readonly GradeTypeEnum TenthGrade    = new GradeTypeEnum(10, "Tenth Grade");
        public static readonly GradeTypeEnum EleventhGrade = new GradeTypeEnum(11, "Eleventh Grade");
        public static readonly GradeTypeEnum TwelfthGrade  = new GradeTypeEnum(12, "Twelfth Grade");
        public GradeTypeEnum(int value, string displayName) : base(value, displayName) { }
    }
}
