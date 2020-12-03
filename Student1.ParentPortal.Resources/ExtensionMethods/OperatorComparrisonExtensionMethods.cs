using Student1.ParentPortal.Resources.Providers.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.ExtensionMethods
{
    public static class OperatorComparrisonExtensionMethods
    {
        public static ThresholdRule<bool> GetRuleThatApplies(this List<ThresholdRule<bool>> rules, bool valueToCompare)
        {
            foreach (var rule in rules)
                if (rule.Evaluate(valueToCompare))
                    return rule;

            throw new ArgumentOutOfRangeException("Could not evaluate value within rules thresholds.");
        }

        public static ThresholdRule<decimal> GetRuleThatApplies(this List<ThresholdRule<decimal>> rules, decimal valueToCompare)
        {
            foreach (var rule in rules)
                if (rule.Evaluate(valueToCompare))
                    return rule;

            throw new ArgumentOutOfRangeException("Could not evaluate value within rules thresholds.");
        }

        public static ThresholdRule<int> GetRuleThatApplies(this List<ThresholdRule<int>> rules, int valueToCompare)
        {
            foreach (var rule in rules)
                if (rule.Evaluate(valueToCompare))
                    return rule;

            throw new ArgumentOutOfRangeException("Could not evaluate value within rules thresholds.");
        }

        public static ThresholdRule<string> GetRuleThatApplies(this List<ThresholdRule<string>> rules, string valueToCompare)
        {
            foreach (var rule in rules)
                if (rule.Evaluate(valueToCompare))
                    return rule;

            throw new ArgumentOutOfRangeException("Could not evaluate value within rules thresholds.");
        }

        public static bool Evaluate(this ThresholdRule<int> rule, int valueToCompare)
        {
            return Evaluate(valueToCompare, rule.@operator, rule.value);
        }

        public static bool Evaluate(this ThresholdRule<decimal> rule, decimal valueToCompare)
        {
            return Evaluate(valueToCompare, rule.@operator, rule.value);
        }

        public static bool Evaluate(this ThresholdRule<bool> rule, bool valueToCompare)
        {
            return Evaluate(valueToCompare, rule.@operator, rule.value);
        }

        public static bool Evaluate(int operand1, string @operator, int operand2)
        {
            switch (@operator)
            {
                case ">":
                    return operand1 > operand2;
                case ">=":
                case "=>":
                    return operand1 >= operand2;
                case "==":
                    return operand1 == operand2;
                case "<":
                    return operand1 < operand2;
                case "<=":
                case "=<":
                    return operand1 <= operand2;
                default:
                    throw new NotImplementedException($"Operator ({@operator}) has not been implemented.");
            }
        }

        public static bool Evaluate(decimal operand1, string @operator, decimal operand2)
        {
            switch (@operator)
            {
                case ">":
                    return operand1 > operand2;
                case ">=":
                case "=>":
                    return operand1 >= operand2;
                case "==":
                    return operand1 == operand2;
                case "<":
                    return operand1 < operand2;
                case "<=":
                case "=<":
                    return operand1 <= operand2;
                default:
                    throw new NotImplementedException($"Operator ({@operator}) has not been implemented.");
            }
        }

        public static bool Evaluate(bool operand1, string @operator, bool operand2)
        {
            switch (@operator)
            {
                case "==":
                    return operand1 == operand2;
                case "!=":
                    return operand1 != operand2;
                default:
                    throw new NotImplementedException($"Operator ({@operator}) has not been implemented.");
            }
        }

        public static bool Evaluate(this ThresholdRule<string> rule, string valueToCompare)
        {
            return Evaluate(valueToCompare, rule.@operator, rule.value);
        }

        public static bool Evaluate(string operand1, string @operator, string operand2)
        {
            switch (@operator)
            {
                case "==":
                    return operand1 == operand2;
                case "!=":
                    return operand1 != operand2;
                default:
                    throw new NotImplementedException($"Operator ({@operator}) has not been implemented.");
            }
        }
    }
}
